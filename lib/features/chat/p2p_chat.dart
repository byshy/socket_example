import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';
import 'package:socketexample/utils/global_widgets/message_item.dart';

import '../../di.dart';
import 'private_chat_provider.dart';

class PrivateChat extends StatefulWidget {
  final ActiveUser user;

  const PrivateChat({Key key, @required this.user}) : super(key: key);

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
        print('equal to zero');
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
      appBar: AppBar(
        key: sl<PrivateChatProvider>().appBarKey,
        title: Text('${widget.user.name}'),
      ),
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
            children: <Widget>[
              Expanded(
                child: instance.messages == null
                    ? Center(
                        child: Text('No messages yet'),
                      )
                    : ListView(
                        controller: sl<PrivateChatProvider>().scrollController,
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
                            key: sl<PrivateChatProvider>().messagesListKey,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int index = instance
                                          .messages[
                                              sl<PrivateChatProvider>().roomId]
                                          .length -
                                      1;
                                  index >= 0;
                                  index--)
                                MessageItem(
                                  key: Key('private_message_$index'),
                                  message: instance.messages[
                                      sl<PrivateChatProvider>().roomId][index],
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
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: sl<PrivateChatProvider>().isSendEnabled
                            ? () => sl<PrivateChatProvider>().sendMessage(
                                  email: widget.user.email,
                                )
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
