import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final double value;
  final double stroke;
  final double size;

  const LoadingIndicator({
    Key key,
    this.color,
    this.value,
    this.backgroundColor,
    this.stroke,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 30,
      width: size ?? 30,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: stroke ?? 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
