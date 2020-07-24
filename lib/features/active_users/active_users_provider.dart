import 'package:flutter/cupertino.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/models/active_user.dart';

import '../../di.dart';

class ActiveUsersProvider with ChangeNotifier {
  Map<String, ActiveUser> _users = {};

  Map<String, ActiveUser> get activeUsers => _users;

  void getActiveUsers() {
    sl<ApiRepo>().getActiveUsers().then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          _users[value[i].email] = value[i];
        }
        notifyListeners();
      }
    });
  }

  void addActiveUser(ActiveUser user) {
    _users[user.email] = user;
    notifyListeners();
  }
}
