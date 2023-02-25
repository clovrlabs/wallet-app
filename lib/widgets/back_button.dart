import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;
  final Color color;

  BackButton({this.onPressed, this.iconData, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(iconData ?? Icons.arrow_back, color: Colors.white),
        onPressed: this.onPressed ??
            () {
              Navigator.pop(context);
            });
  }
}