

import 'package:flutter/material.dart';

class MarkedRect extends StatelessWidget {
  Rect _rect;

  MarkedRect(Offset start, Offset end) {
    _rect = Rect.fromPoints(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _rect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green[900]),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
          ),
        ),
      ),
    );
  }
}