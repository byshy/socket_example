import 'message.dart';

class MessagesPage {
  int index;
  List<Message> messages;

  MessagesPage({this.index, this.messages});

  MessagesPage.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    if (json['messages'] != null) {
      messages = new List<Message>();
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
