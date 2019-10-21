

import 'package:flutter/material.dart';

class MarkedRect extends StatelessWidget {
  Rect _rect;
  Color _markColor;
  Rect get rect => _rect;

  MarkedRect(Offset start, Offset end, this._markColor) {
    _rect = Rect.fromPoints(start, end);
  }

  MarkedRect.empty() {
    Rect _rect = Rect.fromLTRB(0, 0, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _rect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _markColor),
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