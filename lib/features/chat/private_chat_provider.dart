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

  Map<String, List<Message>> _messages = {};
//  List<Message> _messages = List();

//  List<Message> get messages => _messages;
  Map<String, List<Message>> get messages => _messages;

  String roomId;

  void init() {
    sl<SocketService>().socketIO.subscribe('create room', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      if (data['status'] == '200') {
        roomId = data['id'];
        print('room id: $roomId}');
        if (messages[roomId] == null) {
          messages[roomId] = List();
        }
        isRoomCreated = true;
        notifyListeners();
      }
    });
    sl<SocketService>().socketIO.subscribe('private message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('message: $data');
      Message message = Message.fromJson(data);
      if (_messages[data['id']].isNotEmpty) {
        message.sequential = _messages[data['id']].last.from == message.from;
      } else {
        message.sequential = false;
      }
      _messages[data['id']].add(message);
      notifyListeners();
      displayLastMessage();
    });
    sl<SocketService>().socketIO.connect();
  }

  void createRoom({@required String to}) {
    sl<SocketService>().socketIO.sendMessage(
          'create room',
          json.encode({
            'from': sl<LocalRepo>().getUser().data.email,
            'to': to,
          }),
        );
  }

  void sendMessage({String to}) {
    sl<SocketService>().socketIO.sendMessage(
          'private message',
          json.encode({
            'msg': messageController.text.trim(),
            'from': sl<LocalRepo>().getUser().data.email,
            'id': roomId,
          }),
        );
    messageController.text = '';
    isSendEnabled = false;
    notifyListeners();
  }

  void destroy() {
    scrollController.dispose();
    sl<SocketService>().socketIO.unSubscribe('private message');
  }

  void displayLastMessage() {
    Future.delayed(Duration(milliseconds: 50)).then((value) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }
}
