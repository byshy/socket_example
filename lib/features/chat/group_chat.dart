//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:socketexample/data/local_repository.dart';
//import 'package:socketexample/features/active_users/active_users.dart';
//import 'package:socketexample/features/active_users/active_users_provider.dart';
//import 'package:socketexample/features/chat/group_chat_provider.dart';
//import 'package:socketexample/utils/global_widgets/message_item.dart';
//
//import '../../di.dart';
//
//class GroupChat extends StatefulWidget {
//  @override
//  _GroupChatState createState() => _GroupChatState();
//}
//
//class _GroupChatState extends State<GroupChat> {
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//
//  @override
//  void initState() {
//    super.initState();
//    sl<GroupChatProvider>().init();
//    sl<ActiveUsersProvider>().getActiveUsers();
//    getToken();
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//      },
////      onBackgroundMessage: myBackgroundMessageHandler,
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//      },
//    );
//  }
//
//  void getToken() async {
//    String token = await _firebaseMessaging.getToken();
//    sl<LocalRepo>().setFirebaseToken(token);
//    print('firebase token: $token');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: sl<GroupChatProvider>().groupScaffoldKey,
//      endDrawer: ChangeNotifierProvider.value(
//        child: ActiveUsers(),
//        value: sl<ActiveUsersProvider>(),
//      ),
//      appBar: AppBar(
//        title: Text('the memers 🤜🤛'),
//        automaticallyImplyLeading: false,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.info_outline),
//            onPressed: () {
//              sl<GroupChatProvider>()
//                  .groupScaffoldKey
//                  .currentState
//                  .openEndDrawer();
//            },
//          ),
//        ],
//      ),
//      body: Consumer<GroupChatProvider>(
//        builder: (_, instance, child) {
//          return Column(
//            children: <Widget>[
//              Expanded(
//                child: instance.messages == null
//                    ? Center(
//                        child: Text('No messages yet'),
//                      )
//                    : ListView.builder(
//                        controller: sl<GroupChatProvider>().scrollController,
//                        padding: const EdgeInsets.only(bottom: 10),
//                        itemCount: instance.messages.length,
//                        itemBuilder: (context, index) {
//                          return MessageItem(message: instance.messages[index]);
//                        },
//                      ),
//              ),
//              Container(
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: TextField(
//                          controller: sl<GroupChatProvider>().messageController,
//                          maxLines: null,
//                          textInputAction: TextInputAction.send,
//                          onEditingComplete: () {
//                            FocusScope.of(context).requestFocus(FocusNode());
//                          },
//                          onChanged: (val) {
//                            if (val.isEmpty) {
//                              sl<GroupChatProvider>().enableSend(enable: false);
//                            } else {
//                              sl<GroupChatProvider>().enableSend(enable: true);
//                            }
//                          },
//                          decoration: InputDecoration(
//                            hintText: 'message',
//                          ),
//                        ),
//                      ),
//                      IconButton(
//                        icon: Icon(Icons.send),
//                        onPressed: sl<GroupChatProvider>().isSendEnabled
//                            ? () => sl<GroupChatProvider>().sendMessage()
//                            : null,
//                      ),
//                    ],
//                  ),
//                ),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.grey.withOpacity(0.5),
//                      spreadRadius: 3,
//                      blurRadius: 5,
//                      offset: Offset(0, 3),
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          );
//        },
//      ),
//    );
//  }
//}
