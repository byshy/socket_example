import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socketexample/models/user.dart';

class LocalRepo {
  final SharedPreferences sharedPreferences;

  LocalRepo({@required this.sharedPreferences});

  static const String USER = 'user';
  static const String FIREBASE_TOKEN = 'firebase_token';

  Future<void> setFirebaseToken(String token) async {
    await sharedPreferences.setString(FIREBASE_TOKEN, token);
  }

  String getFirebaseToken() {
    return sharedPreferences.getString(FIREBASE_TOKEN);
  }

  Future<void> setUser(User user) async {
    String userJson = jsonEncode(user);
    await sharedPreferences.setString(USER, userJson);
  }

  User getUser() {
    String user = sharedPreferences.getString(USER);
    if (user != null) {
      var map = jsonDecode(sharedPreferences.getString(USER));
      return User.fromJson(map);
    }
    return null;
  }

  void removeUser() {
    sharedPreferences.remove(USER);
  }
}
