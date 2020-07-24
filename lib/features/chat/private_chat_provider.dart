import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/services/socket_service.dart';

import '../../di.dart';

class PrivateChatProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> privateScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isSendEnabled = false;
  bool isRoomCreated = false;

  void enableSend({bool enable}) {
    isSendEnabled = enable;
    notifyListeners();
  }

  List<Message> _messages = List();

  List<Message> get messages => _messages;

  void init() {
    sl<SocketService>().socketIO.subscribe('create room', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('room creation data: $data');
      if (data['status'] == 200) {
        // TODO: display loading indicator
        isRoomCreated = true;
        notifyListeners();
      }
    });
    sl<SocketService>().socketIO.subscribe('private message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      Message message = Message.fromJson(data);
      if (_messages.isNotEmpty) {
        message.sequential = _messages.last.from == data['from'];
      } else {
        message.sequential = false;
      }
      _messages.add(message);
      notifyListeners();
    });
    sl<SocketService>().socketIO.connect();
  }

  void createRoom({@required String to}) {
    print('sending create room message');
    sl<SocketService>().socketIO.sendMessage(
          'create room',
          json.encode({
            'from': sl<LocalRepo>().getUser().data.name,
            'to': to,
          }),
        );
  }

  void sendMessage({String to}) {
    sl<SocketService>().socketIO.sendMessage(
          'private message',
          json.encode({
            'msg': messageController.text,
            'from': sl<LocalRepo>().getUser().data.name,
            'to': to,
          }),
        );
    messageController.text = '';
    isSendEnabled = false;
    notifyListeners();
    if (_messages.isNotEmpty) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  void destroy() {
    scrollController.dispose();
    sl<SocketService>().socketIO.unSubscribe('private message');
  }
}
