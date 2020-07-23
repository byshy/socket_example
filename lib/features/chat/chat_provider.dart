import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/features/active_users/active_users_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/services/socket_service.dart';

import '../../di.dart';

class ChatProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isSendEnabled = false;

  void enableSend({bool enable}) {
    isSendEnabled = enable;
    notifyListeners();
  }

  List<Message> _messages = List();

  List<Message> get messages => _messages;

  void init() {
    print('debugging: starting point');
    sl<SocketService>().socketIO.subscribe('public message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('data: ${data.toString()}');
      _messages.add(
        Message(
          message: data['msg'],
          sender: data['from'],
          sequential: _messages.last.sender == data['from'],
        ),
      );
      notifyListeners();
    });
    print('debugging: subscribed to public message');
    sl<SocketService>().socketIO.subscribe('activeuser', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('activeuser socket data: ${data.toString()}');
      print('activeuser socket data: $jsonData');
      sl<ActiveUsersProvider>().addActiveUser(ActiveUser.fromJson(jsonData));
    });
    print('debugging: subscribed to activeuser');
    sl<SocketService>().socketIO.connect();
  }

  void sendMessage() {
    print('message: ${messageController.text}');
    sl<SocketService>().socketIO.sendMessage(
          'public message',
          json.encode({
            'msg': messageController.text,
            'from': sl<LocalRepo>().getUser().data.name,
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
    sl<SocketService>().socketIO.unSubscribe('public message');
    sl<SocketService>().socketIO.unSubscribe('activeuser');
  }
}
