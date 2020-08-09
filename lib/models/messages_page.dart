import 'message.dart';

class MessagesPage {
  String status;
  List<Message> messages;

  MessagesPage({this.status, this.messages});

  MessagesPage.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      messages = new List<Message>();
      json['data'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['data'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}
