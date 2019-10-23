import 'dart:math';

import 'package:flutter/material.dart';

class MarkedRect extends StatelessWidget {
  Rect _rect;
  final Color _borderColor;
  final BoxConstraints _constraints;

  Rect get rect => _rect;

  MarkedRect({
      @required Offset start,
      @required Offset end,
      @required BoxConstraints constraints,
      @required borderColor})
      : _borderColor = borderColor,
        _constraints = constraints {

    var unconstrainedRect = Rect.fromPoints(start, end);
    _rect = getConstrained(unconstrainedRect, constraints);
  }

  MarkedRect.notMarked()
      : _rect = Rect.fromLTRB(0, 0, 0, 0),
        _borderColor = null,
        _constraints = null;

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

  Rect getConstrained(Rect rect, BoxConstraints constraints)
  {
    double left = max(rect.left, 0);
    double top = max(rect.top, 0);
    double right = min(rect.right, constraints.maxWidth);
    double bottom = min(rect.bottom, constraints.maxHeight);

    return Rect.fromLTRB(left, top, right, bottom);
  }
}
