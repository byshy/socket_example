import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/features/active_users/active_users_provider.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/models/messages_page.dart';
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
      Message message = Message.fromJson(data);
      var temp = sl<PrivateChatProvider>();
      if (temp.messages[data['roomID']] == null) {
        temp.messages[data['roomID']] = List();
        message.sequential = false;
        temp.createRoom(to: data['from'], toID: data['fromID']);
      } else {
        if (temp.messages[data['roomID']].isNotEmpty) {
          message.sequential =
              temp.messages[data['roomID']].last.from == message.from;
        } else {
          message.sequential = false;
        }
      }
      temp.messages[data['roomID']].add(message);
      temp.notifyListeners();
      temp.animateToLastMessage();
    });
    sl<SocketService>().socketIO.subscribe('join room', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      sl<SocketService>().socketIO.sendMessage(
            'join room',
            json.encode(data),
          );
    });
    sl<SocketService>().socketIO.subscribe('create room', (jsonData) async {
      Map<String, dynamic> data = json.decode(jsonData);
      if (data['status'] == '200') {
        var temp = sl<PrivateChatProvider>();
        temp.roomId = data['id'];
        if (temp.messages[temp.roomId] == null) {
          MessagesPage page = await sl<ApiRepo>().getChatPage(
            roomID: temp.roomId,
          );
          temp.messages[temp.roomId] = List();
          for (int index = page.messages.length - 1; index > -1; index--) {
            Message m = page.messages[index];
            if (temp.messages[temp.roomId].isEmpty) {
              m.sequential = false;
            } else {
              if (temp.messages[temp.roomId].last.from == m.from) {
                m.sequential = true;
              } else {
                m.sequential = false;
              }
            }

            print('message: ${m.toString()}');

            temp.messages[temp.roomId].add(m);
          }
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
