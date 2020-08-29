class RoomsList {
  List<Room> rooms;
  String msg;
  String status;

  RoomsList({this.rooms, this.msg, this.status});

  RoomsList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      rooms = new List<Room>();
      json['data'].forEach((v) {
        rooms.add(new Room.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rooms != null) {
      data['data'] = this.rooms.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return 'data: ${rooms.toString()}, msg: $msg, status: $status';
  }
}

class Room {
  String from;
  String to;
  String msg;
  String date;
  String image;
  String roomID;

  Room({
    this.from,
    this.to,
    this.msg,
    this.date,
    this.image,
    this.roomID,
  });

  Room.fromJson(Map<String, dynamic> json) {
    DateTime _date = DateTime.parse(json['date']);
    from = json['from'];
    to = json['to'];
    msg = json['msg'];
    date =
        '${_date.year}-${_date.month}-${_date.day} ${_date.hour}:${_date.minute}';
    image = json['image'];
    roomID = json['roomID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['msg'] = this.msg;
    data['date'] = this.date;
    data['image'] = this.image;
    data['roomID'] = this.roomID;
    return data;
  }

  @override
  String toString() {
    return 'from: $from, to: $to, msg: $msg, date: $date, roomID: $roomID';
  }
}
