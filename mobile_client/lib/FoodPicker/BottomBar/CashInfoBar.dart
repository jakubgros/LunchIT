import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Basket/BasketData.dart';
import 'package:provider/provider.dart';

class CashInfoBar extends StatelessWidget {
  final double _moneyLeft = 100.0; //TODO dehardcode

  @override
  Widget build(BuildContext context) {
    return Consumer<BasketData>(
      builder:  (context, basketData, child) =>
     Container(
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
                      "Suma: ${basketData.getSummaryCost()} zl",
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
      ),
    );
  }
}
