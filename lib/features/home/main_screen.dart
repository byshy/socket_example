import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/utils/colors.dart';

import '../../di.dart';
import 'home_provider.dart';
import 'sub/home.dart';
import 'sub/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<Widget> pages = [
    Home(username: sl<LocalRepo>().getUser().data.username),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sl<HomeProvider>().init();
    });
    getToken();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  void getToken() async {
    String token = await _firebaseMessaging.getToken();
    sl<LocalRepo>().setFirebaseToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[currentPage],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      selectedItemColor: blue34BBB3,
      unselectedItemColor: Colors.black,
      onTap: (page) {
        setState(() {
          currentPage = page;
        });
      },
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Profile'),
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
