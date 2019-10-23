import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CashInfoBar extends StatelessWidget {
  final double _moneySpent;
  final double _moneyLeft;

  CashInfoBar(this._moneySpent, this._moneyLeft);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: Colors.blue[700]),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Suma: ${_moneySpent.toStringAsFixed(2)} zl",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Pozostalo: ${_moneyLeft.toStringAsFixed(2)} zl",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
