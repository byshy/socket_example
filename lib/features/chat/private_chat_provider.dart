import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/models/messages_page.dart';
import 'package:socketexample/services/socket_service.dart';

import '../../di.dart';

class PrivateChatProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> privateScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final GlobalKey messagesListKey = GlobalKey();
  final GlobalKey appBarKey = GlobalKey();
  final GlobalKey bottomRowKey = GlobalKey();

  bool isSendEnabled = false;
  bool isRoomCreated = false;
  bool beenSubscribedBefore = false;
  bool otherIsTyping = false;

  void enableSend({bool enable}) {
    isSendEnabled = enable;
    notifyListeners();
  }

  Map<String, List<Message>> _messages = {};

  Map<String, List<Message>> get messages => _messages;

  String roomId;

  Timer _timer;

  void init() {
    if (!beenSubscribedBefore) {
      beenSubscribedBefore = true;
      sl<SocketService>().socketIO.subscribe('typing', (jsonData) {
        Map<String, dynamic> data = json.decode(jsonData);
        if (data['from'] != sl<LocalRepo>().getUser().data.email) {
          otherIsTyping = true;
          notifyListeners();
          if (_timer != null) {
            _timer.cancel();
          }
          _timer = Timer(Duration(seconds: 1), () {
            otherIsTyping = false;
            notifyListeners();
          });
        }
      });
    }
  }

  void getDimensions() async {
    final RenderBox messagesListRenderBox =
        messagesListKey.currentContext.findRenderObject();
    final RenderBox appBarRenderBox =
        appBarKey.currentContext.findRenderObject();
    final RenderBox bottomRowRenderBox =
        bottomRowKey.currentContext.findRenderObject();
    final RenderBox privateScaffoldRenderBox =
        privateScaffoldKey.currentContext.findRenderObject();

    final double privateScaffoldHeight = privateScaffoldRenderBox.size.height;

    final double totalContentHeight = messagesListRenderBox.size.height +
        appBarRenderBox.size.height +
        bottomRowRenderBox.size.height;

    if (totalContentHeight <= privateScaffoldHeight) {
      MessagesPage page = await sl<ApiRepo>().getChatPage(
        roomID: roomId,
        skip: messages[roomId].length,
      );
      for (int index = page.messages.length - 1; index > -1; index--) {
        Message m = page.messages[index];
        if (index == page.messages.length - 1) {
          m.sequential = false;
        } else {
          if (messages[roomId][0].from == m.from) {
            m.sequential = true;
          } else {
            m.sequential = false;
          }
        }

        print('message: ${m.toString()}');

        messages[roomId].insert(page.messages.length - 1 - index, m);

        if (index == 0) {
          notifyListeners();
          animateToLastMessage(milliseconds: 70);
        }
      }
    }
  }

  void createRoom({@required String to, @required String toID}) {
    isRoomCreated = false;
    notifyListeners();
    sl<SocketService>().socketIO.sendMessage(
          'create room',
          json.encode({
            'from': sl<LocalRepo>().getUser().data.email,
            'to': to,
            'toID': toID,
          }),
        );
  }

  void sendMessage() {
    sl<SocketService>().socketIO.sendMessage(
          'private message',
          json.encode({
            'msg': messageController.text.trim(),
            'from': sl<LocalRepo>().getUser().data.email,
            'roomID': roomId,
          }),
        );
    messageController.text = '';
    isSendEnabled = false;
    notifyListeners();
  }

  void animateToLastMessage({int milliseconds}) {
    Future.delayed(Duration(milliseconds: milliseconds ?? 50)).then((value) {
      try {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      } catch (e) {
        print('scrollController is not attached to a scrollable view');
      }
    });
  }

  void sendIsTyping() {
    sl<SocketService>().socketIO.sendMessage(
          'typing',
          json.encode({
            'from': sl<LocalRepo>().getUser().data.email,
            'roomID': roomId,
          }),
        );
  }
}
