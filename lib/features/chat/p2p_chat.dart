import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';
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
    sl<PrivateChatProvider>().scrollController.addListener(() {
      if (sl<PrivateChatProvider>().scrollController.position.pixels == 0 &&
          !sl<PrivateChatProvider>().showLoading) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          sl<PrivateChatProvider>().getNextPage(makeMargin: true);
        });
      }
    });
  }

  @override
  void dispose() {
    sl<PrivateChatProvider>().scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<PrivateChatProvider>().privateScaffoldKey,
      backgroundColor: Colors.black,
      body: Consumer<PrivateChatProvider>(
        builder: (_, instance, child) {
          if (!instance.isRoomCreated) {
            return Center(
              child: LoadingIndicator(
                color: Colors.blue,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        key: sl<PrivateChatProvider>().appBarKey,
                        title: Text('${widget.username}'),
                      ),
                      Expanded(
                        child: instance.messages == null
                            ? Center(
                                child: Text('No messages yet'),
                              )
                            : ListView(
                                controller:
                                    sl<PrivateChatProvider>().scrollController,
                                padding: const EdgeInsets.only(bottom: 10),
                                shrinkWrap: true,
                                children: [
                                  AnimatedContainer(
                                    height: instance.showLoading ? 60 : 0,
                                    duration: Duration(
                                      milliseconds: 100,
                                    ),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LoadingIndicator(),
                                    )),
                                  ),
                                  Column(
                                    key: sl<PrivateChatProvider>()
                                        .messagesListKey,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int index = instance
                                                  .messages[
                                                      sl<PrivateChatProvider>()
                                                          .roomId]
                                                  .length -
                                              1;
                                          index >= 0;
                                          index--)
                                        MessageItem(
                                          key: Key('private_message_$index'),
                                          message: instance.messages[
                                              sl<PrivateChatProvider>()
                                                  .roomId][index],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                      Visibility(
                        visible: instance.otherIsTyping,
                        child: Image.asset('assets/gifs/kermit_typing.gif'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                key: sl<PrivateChatProvider>().bottomRowKey,
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
                          style: TextStyle(color: Colors.white),
                          onChanged: (val) {
                            sl<PrivateChatProvider>().sendIsTyping();
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
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: sl<PrivateChatProvider>().isSendEnabled
                            ? () => sl<PrivateChatProvider>().sendMessage(
                                  username: widget.username,
                                )
                            : null,
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
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
