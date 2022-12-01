class Message {
  final List? message;
  final pageState;
  final bool? end;

  Message({
    required this.message,
    required this.pageState,
    required this.end,
  });

  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(
      message: message['message'],
      pageState: message['pageState'],
      end: message['end'],
    );
  }
}
