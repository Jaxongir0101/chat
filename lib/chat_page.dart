import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:untitled3/mainview.dart';
import 'message.dart';

class GroupItems extends StatefulWidget {
  final slug;
  final id;
  GroupItems({super.key, required this.slug, required this.id});

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  void sendMessage(String message) {
    String messageText = message.trim();
    message = '';

    if (messageText != '') {
      socket.emit('message', {
        "id": widget.id,
        "userId": 168,
        "type": "text",
        "message": messageText,
        "channelSlug": widget.slug,
        "isReply": false,
        "hashtags": null,
        "relevance": 0,
        "mediaUrl": null,
        "mediaTitle": null,
        "msgLocation": null,
        "minRelevance": null,
        "taggedUserId": 0,
        "videoThumbnail": null,
        "originMessageId": null,
        "originMessageTimestamp": null,
        "originRelevance": null,
      });
    }
    _messageController.clear();
  }

  _connectSocket() {
    socket = io(
      'http://e-camp.uz',
      OptionBuilder().setTransports(['websocket']).setQuery(
        <dynamic, dynamic>{'userId': 168},
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
      _isLoading = false;
    });
  }

  Stream generateNumbers = (() async* {

    socket.on('message', (data) {
      Provider.of<MessageView>(context, listen: false)
          .addNewMessage(Message.fromJson(data));
    });
  })();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    socket.close();
    socket.dispose();
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
          StreamBuilder(builder: (
            context,
            AsyncSnapshot<int> snapshot,
          ) {
            return Expanded(
              child: Consumer<MessageView>(
                builder: (context, value, child) {
                  if (!_isLoading && value.messages.isNotEmpty) {
                    final messages = value.messages[0].message;
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        messages.reversed;
                        final message = messages[index]["message"];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: messages?[index]['userId'] == -1
                              ? MainAxisAlignment.center
                              : messages?[index]['userId'] == 168
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            messages?[index]['userId'] != -1
                                ? Container(
                                    margin: EdgeInsets.only(top: 42),
                                    padding: EdgeInsets.all(8),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color(0xff056676).withAlpha(96),
                                            offset: Offset(16, 24),
                                            blurRadius: 96,
                                            spreadRadius: 32,
                                          ),
                                        ]),
                                    child: Text(
                                      message ?? "--",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : Text(
                                    message ?? "--",
                                  )
                          ],
                        );
                      },
                      itemCount: messages.length ?? 0,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            );
          }),
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
                        sendMessage(_messageController.text);
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
