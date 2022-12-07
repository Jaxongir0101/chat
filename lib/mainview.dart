import 'package:flutter/widgets.dart';
import 'package:untitled3/message.dart';

class MessageView extends ChangeNotifier {
  List _messages = [];

  List get messages => _messages;

  addNewMessage(Message message) {
    _messages.clear();
    _messages = [message];
    notifyListeners();
  }
}
