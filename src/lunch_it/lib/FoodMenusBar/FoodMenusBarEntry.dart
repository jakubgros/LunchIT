import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FoodMenusBarEntry extends StatelessWidget
{
  final VoidCallback _onTapCallback;
  final String _title;

  FoodMenusBarEntry(this._title, this._onTapCallback);

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
                )
            ),
          ),
        ),
      ),
    );
  }
}