import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  final void Function() onPressed;
  final Icon icon;
  final Text label;

  LabeledIconButton(
      {@required this.onPressed, @required this.icon, @required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: <Widget>[
              icon,
              label,
            ],
          ),
        ));
  }
}
