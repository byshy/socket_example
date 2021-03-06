import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/di.dart' as di;

import 'di.dart';
import 'services/navigation_service.dart';
import 'utils/colors.dart';
import 'utils/routing/router.dart';
import 'utils/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket.IO Demo',
      theme: ThemeData(
        primarySwatch: blue34BBB3,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: sl<NavigationService>().navigatorKey,
      initialRoute: sl<LocalRepo>().getUser() == null ? login : mainScreen,
//      initialRoute: sl<LocalRepo>().getUser() == null ? login : groupChat,
      onGenerateRoute: Router.generateRoute,
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    print('myBackgroundMessageHandler data: ${data.toString()}');
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
    print(
        'myBackgroundMessageHandler notification: ${notification.toString()}');
  }
}
