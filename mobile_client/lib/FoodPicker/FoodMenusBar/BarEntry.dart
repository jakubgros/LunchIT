import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarEntry extends StatelessWidget {
  final VoidCallback _onTapCallback;
  final String _title;

  BarEntry({
    @required title,
    @required onTap,
  })  : _title = title,
        _onTapCallback = onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _onTapCallback,
        child: FractionallySizedBox(
          heightFactor: 1 / 2,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(_title),
            )),
          ),
        ),
      ),
    );
  }
}
