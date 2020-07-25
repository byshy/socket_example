import 'package:flutter/material.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/models/message.dart';

import '../../di.dart';

class MessageItem extends StatefulWidget {
  final Message message;

  const MessageItem({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool _isMine;

  @override
  void initState() {
    super.initState();
    _isMine = widget.message.from == sl<LocalRepo>().getUser().data.email;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          _isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: _isMine,
          child: SizedBox(width: 60),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: !_isMine,
                child: SizedBox(height: 8.0),
              ),
              Visibility(
                visible: !_isMine && !widget.message.sequential,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('${widget.message.from}'),
                ),
              ),
              Card(
                color: _isMine ? Colors.blue : Colors.grey[200],
                margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: _isMine ? 8.0 : 0.0,
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
                    '${widget.message.msg}',
                    style: TextStyle(
                      color: _isMine ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !_isMine,
          child: SizedBox(width: 60),
        ),
      ],
    );
  }
}
