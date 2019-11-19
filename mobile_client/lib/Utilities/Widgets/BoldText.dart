import 'package:flutter/widgets.dart';

class BoldText extends StatelessWidget {
  final String text;
  final Color color;
  BoldText(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ));
  }
}
