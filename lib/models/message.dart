class Message {
  String msg;
  String from;
  bool sequential;

  Message({this.msg, this.from, this.sequential});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msg: json['msg'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['from'] = this.from;
    return data;
  }

  @override
  String toString() {
    return 'msg: $msg, from: $from, sequential: $sequential';
  }
}
