import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key key,
    @required this.text,
    @required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 8,
      backgroundColor: color,
      foregroundColor: Colors.white,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
  }
}
