import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:untitled3/mainview.dart';
import 'message.dart';

class GroupItems extends StatefulWidget {
  final slug;
  final id;
   GroupItems({
    super.key,
    required this.slug,
     required this.id
  });

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  bool isFocus = false;
  bool isUpArrow = false;
  late IO.Socket socket;
  TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    socket.emit('message',_messageController.text);
    print("emit");
    _messageController.clear();
  }

  _connectSocket() {
    socket = io(
      'http://e-camp.uz',
      OptionBuilder().setTransports(['websocket']).setQuery(
        <dynamic, dynamic>{'userId': widget.id},
      ).build(),
    );
    socket.connect();

    socket.onConnect((data) {
      print("connect");
    });

    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    socket.emit('history', {
      "pageState": null,
      "relevance": null,
      "hashtags": null,
      "channelSlug": widget.slug,
    });
    socket.on('history', (data) {
      print(data);
      Provider.of<MessageView>(context, listen: false)
          .addNewMessage(Message.fromJson(data));
    });
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat ${widget.id}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageView>(builder: (context, value, child) {
              if (value.messages.isNotEmpty) {
                final messages = value.messages[0].message;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return Wrap(
                      children: [
                        Card(

                          child: Padding(
                            padding:  EdgeInsets.all(index+2),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index]['message'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 34),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: messages.length ?? 0,
                );
              } else {
                return const Text('Loading...');
              }
            }),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        sendMessage();
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
