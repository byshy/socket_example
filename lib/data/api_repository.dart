import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/messages_page.dart';
import 'package:socketexample/models/rooms_list.dart';
import 'package:socketexample/models/user.dart';

import '../di.dart';

class ApiRepo {
  final Dio client;

  ApiRepo({@required this.client});

  Future<User> login({Map<String, dynamic> data}) async {
    Response response;

    try {
      response = await client.post('login', data: data);
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
      return User(errorMessage: e.response.data['msg']);
    }

    User user;

    user = User.fromJson(response.data);

    return user;
  }

  Future<User> signUp({Map<String, dynamic> data}) async {
    Response response;

    try {
      response = await client.post('signup', data: data);
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    User user;

    user = User.fromJson(response.data);

    return user;
  }

  Future<String> setProfileImage({FormData data}) async {
    Response response;

    try {
      response = await client.post('upload_image', data: data);
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    String image;

    image = response.data['data'].toString();

    sl<LocalRepo>().setUserImage(image: image);

    return image;
  }

  Future<List<ActiveUser>> getActiveUsers() async {
    Response response;

    try {
      response = await client.get('activeuser');
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    List<ActiveUser> users = List();

    response.data['data'].forEach((v) {
      if (v != null) {
        users.add(ActiveUser.fromJson(v));
      }
    });

    return users;
  }

  Future<MessagesPage> getChatPage({int skip, String roomID}) async {
    Response response;

    try {
      response = await client.get(
        'messages/$roomID/$skip',
      );
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    MessagesPage messagesPage;

    messagesPage = MessagesPage.fromJson(response.data);

    return messagesPage;
  }

  Future<RoomsList> getChats({int skip}) async {
    Response response;

    try {
      response = await client.get(
        'getrooms/$skip',
      );
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    RoomsList roomsList;

    roomsList = RoomsList.fromJson(response.data);

    return roomsList;
  }
}
