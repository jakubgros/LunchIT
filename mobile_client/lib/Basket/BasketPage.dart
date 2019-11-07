import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Basket/BasketData.dart';
import 'package:lunch_it/Basket/BasketEntry.dart';
import 'package:lunch_it/Basket/BasketEntryCard.dart';
import 'package:lunch_it/Basket/PlaceOrderButton.dart';
import 'package:lunch_it/FoodPicker/BottomBar/CashInfoBar.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Consumer<BasketData>(builder: (context, basketData, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("#MAIL TITLE#"), //TODO dehardcode
        ),
        body: ListView.builder(
          itemCount: basketData.length,
          itemBuilder: (context, index) =>
              basketEntryBuilder(basketData, index),
        ),
        bottomSheet: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PlaceOrderButton(),
              CashInfoBar(),
            ],
          ),
        ));
    });
}

Widget basketEntryBuilder(BasketData basketData, int index) {
  BasketEntry entry = basketData.getEntry(index);

  return BasketEntryCard.modifiable(entry, index, basketData);
}

