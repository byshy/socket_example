import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/features/chat/group_chat.dart';
import 'package:socketexample/features/chat/group_chat_provider.dart';
import 'package:socketexample/features/chat/p2p_chat.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/features/login/login.dart';
import 'package:socketexample/features/login/login_provider.dart';
import 'package:socketexample/features/sign_up/sign_up.dart';
import 'package:socketexample/features/sign_up/sign_up_provider.dart';

import '../../di.dart';
import 'routes.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            child: Login(),
            value: sl<LoginProvider>(),
          ),
        );
      case signUp:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            child: SignUp(),
            value: sl<SignUpProvider>(),
          ),
        );
      case groupChat:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            child: GroupChat(),
            value: sl<GroupChatProvider>(),
          ),
        );
      case privateChat:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            child: PrivateChat(
              username: settings.arguments,
            ),
            value: sl<PrivateChatProvider>(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
