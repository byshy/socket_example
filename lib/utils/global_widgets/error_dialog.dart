import 'package:flutter/material.dart';

void showErrorDialog({
  BuildContext context,
  @required String title,
  String message,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(_);
            },
          ),
        ],
      );
    },
  );
}
