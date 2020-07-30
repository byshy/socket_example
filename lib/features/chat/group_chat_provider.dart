import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/features/active_users/active_users_provider.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/services/socket_service.dart';

import '../../di.dart';

class GroupChatProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> groupScaffoldKey = GlobalKey<ScaffoldState>();
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
    sl<SocketService>().socketIO.subscribe('public message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      Message message = Message.fromJson(data);
      if (_messages.isNotEmpty) {
        message.sequential = _messages.last.from == message.from;
      } else {
        message.sequential = false;
      }
      _messages.add(message);
      notifyListeners();
      animateToLastMessage();
    });
    sl<SocketService>().socketIO.subscribe('private message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print('message: $data');
      Message message = Message.fromJson(data);
      var temp = sl<PrivateChatProvider>();
      if (temp.messages[data['id']] == null) {
        temp.messages[data['id']] = List();
        temp.createRoom(to: data['from'], toID: data['fromID']);
      } else {
        if (temp.messages[data['id']].isNotEmpty) {
          message.sequential =
              temp.messages[data['id']].last.from == message.from;
        } else {
          message.sequential = false;
        }
        temp.messages[data['id']].add(message);
        temp.notifyListeners();
        temp.animateToLastMessage();
      }
    });
    sl<SocketService>().socketIO.subscribe('create room', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      if (data['status'] == '200') {
        var temp = sl<PrivateChatProvider>();
        temp.roomId = data['id'];
        print('room id: ${temp.roomId}}');
        if (temp.messages[sl<PrivateChatProvider>().roomId] == null) {
          temp.messages[temp.roomId] = List();
        }
        temp.isRoomCreated = true;
        temp.notifyListeners();
      }
    });
    sl<SocketService>().socketIO.subscribe('activeuser', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      sl<ActiveUsersProvider>().addActiveUser(ActiveUser.fromJson(data));
    });
  }

  void sendMessage() {
    sl<SocketService>().socketIO.sendMessage(
          'public message',
          json.encode({
            'msg': messageController.text.trim(),
            'from': sl<LocalRepo>().getUser().data.email,
          }),
        );
    messageController.text = '';
    isSendEnabled = false;
    notifyListeners();
  }

  void destroy() {
    scrollController.dispose();
    sl<SocketService>().socketIO.unSubscribe('public message');
    sl<SocketService>().socketIO.unSubscribe('activeuser');
  }

  void animateToLastMessage() {
    Future.delayed(Duration(milliseconds: 50)).then((value) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }
}
