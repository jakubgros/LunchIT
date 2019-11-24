import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/OrderResponseBloc.dart';
import 'package:lunch_it/DataModels/OrderResponseInfoModel.dart';
import 'package:provider/provider.dart';

class CashInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderResponseInfoModel>(
      stream: Provider.of<OrderResponseBloc>(context).orderInfo,
      builder:  (context, orderInfo) {
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
                        "Suma: ${orderInfo.hasData ? orderInfo.data.summaryCost.toStringAsFixed(2) : ""} zl",
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
                          "Pozostalo: ${orderInfo.hasData ? orderInfo.data.moneyLeft.toStringAsFixed(2) : ""} zl",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            backgroundColor: orderInfo.hasData == true && orderInfo.data.moneyLeft<0 ? Colors.red : null,
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
