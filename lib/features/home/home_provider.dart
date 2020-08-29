import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/message.dart';
import 'package:socketexample/models/messages_page.dart';
import 'package:socketexample/models/rooms_list.dart';
import 'package:socketexample/services/socket_service.dart';

import '../../di.dart';

class HomeProvider with ChangeNotifier {
  PickedFile image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    image = PickedFile(pickedFile.path);
    notifyListeners();
  }

  List<ActiveUser> _users = List();

  List<ActiveUser> get activeUsers => _users;

  void getActiveUsers() {
    sl<ApiRepo>().getActiveUsers().then((value) {
      if (value != null) {
        _users = value;
        notifyListeners();
      }
    });
  }

  void addActiveUser(ActiveUser user) {
    if (!_users.contains(user)) {
      _users.add(user);
      notifyListeners();
    }
  }

  void init() {
    getActiveUsers();
    if (roomsList.rooms.isEmpty) {
      getChats();
    }
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
      temp.messages[data['roomID']].insert(0, message);
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
        print('roomID: ${temp.roomId}');
        if (temp.messages[temp.roomId] == null) {
          MessagesPage page =
              await sl<ApiRepo>().getChatPage(roomID: temp.roomId, skip: 0);
          temp.messages[temp.roomId] = List();
          for (int index = 0; index < page.messages?.length ?? 0; index++) {
            Message m = page.messages[index];
            try {
              if (page.messages[index + 1].from == m.from) {
                m.sequential = true;
              } else {
                m.sequential = false;
              }
            } catch (_) {
              m.sequential = false;
            }

            temp.messages[temp.roomId].add(m);
          }
        }
        temp.isRoomCreated = true;
        temp.notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          temp.getDimensions();
        });
      }
    });
    sl<SocketService>().socketIO.subscribe('activeuser', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      addActiveUser(ActiveUser.fromJson(data));
    });
  }

  bool isUploadingProfileImage = false;

  void setProfileImage() async {
    isUploadingProfileImage = true;
    notifyListeners();
    print('${image.path}');
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        image.path,
        filename: 'profile_image',
      ),
    });
    print('formData: ${formData.toString()}');
    sl<ApiRepo>().setProfileImage(data: formData).then((value) {
      isUploadingProfileImage = false;
      notifyListeners();
    });
  }

  RoomsList roomsList = RoomsList(rooms: List());

  bool chatRoomsLoading = false;

  void getChats() {
    chatRoomsLoading = true;
    notifyListeners();
    sl<ApiRepo>().getChats(skip: roomsList.rooms.length).then((value) {
      chatRoomsLoading = false;
      roomsList = value;
      notifyListeners();
    });
  }
}
