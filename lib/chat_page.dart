import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:untitled3/mainview.dart';
import 'message.dart';

class GroupItems extends StatefulWidget {

  const GroupItems({super.key,});

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  bool isFocus = false;
  bool isUpArrow = false;
  late IO.Socket socket;
  TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    socket.emit("message", _messageController.text.trim());
    print("emit");
    _messageController.clear();
  }

  _connectSocket() {
    socket = io(
      'http://e-camp.uz',
      OptionBuilder().setTransports(['websocket']).setQuery(
        <dynamic, dynamic>{'userId': 171},
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
      "channelSlug": "d4ef5da4-e7f0-47b3-a84f-571d7c656adc",
    });
    socket.on('history', (data) {
      print(data);
      MessageView mainView = Provider.of<MessageView>(context, listen: false);
      mainView.addNewMessage(Message.fromJson(data));
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
        title: Text("171"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageView>(builder: (context, value, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Wrap(
                    children: [
                      Card(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.messages[index].message ?? "",
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
                itemCount: value.messages.length,
              );
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
                        //  sendMessage();
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