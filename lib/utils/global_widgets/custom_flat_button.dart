import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const CustomFlatButton({Key key, this.onPressed, this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        height: 40,
        child: Center(child: child),
      ),
      color: color ?? Colors.grey[300],
    );
  }
}
