import 'package:flutter/material.dart';

class MarkedRect extends StatelessWidget {
  final Rect _rect;
  final Color _borderColor;

  Rect get rect => _rect;

  MarkedRect(
      {@required Offset start, @required Offset end, @required borderColor})
      : _borderColor = borderColor,
        _rect = Rect.fromPoints(start, end);

  MarkedRect.notMarked()
      : _rect = Rect.fromLTRB(0, 0, 0, 0),
        _borderColor = null;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _rect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(),
        ),
      ),
    );
  }
}
