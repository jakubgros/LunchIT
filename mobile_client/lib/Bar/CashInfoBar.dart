import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BasketBloc.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:provider/provider.dart';

class CashInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BasketBloc>(
      builder:  (context, basketBloc, child) {
        final double priceLimit = Provider.of<CurrentOrderRequestModel>(context, listen:false).priceLimit;
        final double moneySpent = basketBloc.getSummaryCost();
        final double moneyLeft = priceLimit - moneySpent;

        return Container(
          decoration: BoxDecoration(
              border: Border.all(), color: Colors.blue[700]),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Suma: ${moneySpent.toStringAsFixed(2)} zl",
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
                      child: Text(
                          "Pozostalo: ${moneyLeft.toStringAsFixed(2)} zl",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            backgroundColor: moneyLeft<0 ? Colors.red : null,
                            color: Colors.white,
                          )),
                    ),
                  )),
            ],
          ),
        );
      }
    );
  }
}
