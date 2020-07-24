import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/features/active_users/active_users.dart';
import 'package:socketexample/features/active_users/active_users_provider.dart';
import 'package:socketexample/features/chat/chat_provider.dart';
import 'package:socketexample/models/message.dart';

import '../../di.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  void initState() {
    super.initState();
    sl<ChatProvider>().init();
    sl<ActiveUsersProvider>().getActiveUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<ChatProvider>().scaffoldKey,
      endDrawer: ChangeNotifierProvider.value(
        child: ActiveUsers(),
        value: sl<ActiveUsersProvider>(),
      ),
      appBar: AppBar(
        title: Text('the memers 🤜🤛'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              sl<ChatProvider>().scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (_, instance, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: instance.messages == null
                    ? Center(
                        child: Text('No messages yet'),
                      )
                    : ListView.builder(
                        controller: sl<ChatProvider>().scrollController,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: instance.messages.length,
                        itemBuilder: (context, index) {
                          return messageItem(message: instance.messages[index]);
                        },
                      ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: sl<ChatProvider>().messageController,
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          onChanged: (val) {
                            if (val.isEmpty) {
                              sl<ChatProvider>().enableSend(enable: false);
                            } else {
                              sl<ChatProvider>().enableSend(enable: true);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: sl<ChatProvider>().isSendEnabled
                            ? () => sl<ChatProvider>().sendMessage()
                            : null,
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget messageItem({Message message, bool showName}) {
    bool isMine = message.from == sl<LocalRepo>().getUser().data.name;

    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: isMine,
          child: SizedBox(width: 60),
        ),
        Flexible(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: !isMine,
                child: SizedBox(height: 8.0),
              ),
              Visibility(
                visible: !isMine,
                child: Text('${message.from}'),
              ),
              Card(
                color: isMine ? Colors.blue : Colors.grey[200],
                margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: isMine ? 8.0 : 0.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${message.msg}',
                    style: TextStyle(
                      color: isMine ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !isMine,
          child: SizedBox(width: 60),
        ),
      ],
    );
  }
}
