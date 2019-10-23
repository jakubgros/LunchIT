import 'package:flutter/material.dart';

import 'CashInfoBar.dart';
import 'OrderingTools.dart';

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: OrderingTools(),
          ),
          Expanded(flex: 1, child: CashInfoBar(12.34, 56.78) //TODO dehardcode
              )
        ],
      ),
    );
  }
}
