import 'package:flutter/material.dart';
import 'package:lunch_it/BottomMenu/CashInfoBar.dart';
import 'package:lunch_it/BottomMenu/OrderingTools.dart';

class BottomMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: OrderingTools(),
          ),
          Expanded(
              flex: 1,
              child: CashInfoBar(12.34, 56.78) //TODO dehardcode
          )
        ],
      ),
    );
  }
}
