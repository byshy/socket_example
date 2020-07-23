import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/di.dart' as di;

import 'di.dart';
import 'services/navigation_service.dart';
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: sl<NavigationService>().navigatorKey,
      initialRoute: sl<LocalRepo>().getUser() == null ? login : groupChat,
      onGenerateRoute: Router.generateRoute,
    );
  }
}