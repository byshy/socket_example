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
          _users[value[i].id] = value[i];
        }
        print('_users: ${_users.toString()}');
        notifyListeners();
      } else {
        print('_users value is null');
      }
    });
  }

  void addActiveUser(ActiveUser user) {
    print('');
    _users[user.id] = user;
    notifyListeners();
  }
}
