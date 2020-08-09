import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/messages_page.dart';
import 'package:socketexample/models/user.dart';

class ApiRepo {
  final Dio client;

  ApiRepo({@required this.client});

  Future<User> login({Map<String, dynamic> data}) async {
    Response response;

    try {
      response = await client.post('login', data: data);
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    User user;

    if (response.statusCode == 200) {
      user = User.fromJson(response.data);
    }

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

    if (response.statusCode == 200) {
      user = User.fromJson(response.data);
    }

    return user;
  }

  Future<List<ActiveUser>> getActiveUsers() async {
    Response response;

    try {
      response = await client.get('activeuser');
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    List<ActiveUser> users = List();

    if (response.statusCode == 200) {
      response.data['data'].forEach((v) {
        if (v != null) {
          users.add(ActiveUser.fromJson(v));
        }
      });
    }

    return users;
  }

  Future<MessagesPage> getChatPage({int index, String roomID}) async {
    Response response;

    print('index: $index');
    print('roomID: $roomID');

    try {
      response = await client.post(
        'messages',
        data: {
          'index': index,
          'room': roomID,
        },
      );
    } on DioError catch (e) {
      print('e: ${e.response.toString()}');
    }

    MessagesPage messagesPage;

    print('old messages response: ${response.data}');

    if (response.statusCode == 200) {
      messagesPage = MessagesPage.fromJson(response.data);
    }

    return messagesPage;
  }
}
