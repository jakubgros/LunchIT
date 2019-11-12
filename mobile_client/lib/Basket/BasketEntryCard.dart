
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';
import 'package:lunch_it/HomePage/HomePage.dart';

import 'BasketData.dart';
import 'BasketEntry.dart';

class BasketEntryCard extends StatelessWidget {
  final BasketEntry entry;
  BasketData basketData;
  final bool _isModifiable;
  int index;

  BasketEntryCard.modifiable(this.entry, this.index, this.basketData):
      _isModifiable = true;

  BasketEntryCard.presenter(this.entry):
      _isModifiable = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        margin: EdgeInsets.only(top: 3, left: 5, right: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BoldText(entry.foodName),
                  Text("${entry.price} x ${entry.quantity} = ${entry.price *
                      entry.quantity}")
                ],
              ),
              if(entry.comment != null) Text("(${entry.comment})"),
              if (_isModifiable == true) Column(
                children: <Widget>[
                  Divider(color: Colors.black),
                  Row(
                    children: <Widget>[
                      QuantityManager(
                        initVal: entry.quantity,
                        onChanged: (int quantity) => entry.quantity = quantity,
                      ),
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.remove),
                        color: Colors.red[300],
                        onPressed: () => basketData.removeEntry(index),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        )

    );
  }
}