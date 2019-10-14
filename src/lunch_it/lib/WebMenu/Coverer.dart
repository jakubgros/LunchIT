
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Coverer extends StatelessWidget {
  bool _shouldCover;

  Coverer(this._shouldCover);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _shouldCover,
      child: SizedBox(
        child: Container(
          child: Column(
            children: <Widget>[
              Spacer()
            ],
          ),
          color: Colors.red[500],
        ),
        height: 1000,
        width: 1000,
      ),
    );
  }
}