import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/utils/global_widgets/message_item.dart';

import '../../di.dart';
import 'private_chat_provider.dart';

class PrivateChat extends StatefulWidget {
  final String username;

  const PrivateChat({Key key, @required this.username}) : super(key: key);

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  @override
  void initState() {
    super.initState();
    sl<PrivateChatProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<PrivateChatProvider>().privateScaffoldKey,
      appBar: AppBar(
        title: Text('${widget.username}'),
      ),
      body: Consumer<PrivateChatProvider>(
        builder: (_, instance, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: instance.messages == null
                    ? Center(
                        child: Text('No messages yet'),
                      )
                    : ListView.builder(
                        controller: sl<PrivateChatProvider>().scrollController,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: instance.messages.length,
                        itemBuilder: (context, index) {
                          return MessageItem(
                            message: instance.messages[index],
                          );
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
                          controller:
                              sl<PrivateChatProvider>().messageController,
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          onChanged: (val) {
                            if (val.isEmpty) {
                              sl<PrivateChatProvider>()
                                  .enableSend(enable: false);
                            } else {
                              sl<PrivateChatProvider>()
                                  .enableSend(enable: true);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: sl<PrivateChatProvider>().isSendEnabled
                            ? () => sl<PrivateChatProvider>()
                                .sendMessage(to: widget.username)
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
}
