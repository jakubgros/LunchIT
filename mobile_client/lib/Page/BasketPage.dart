import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Basket/Model/Basket.dart';
import 'package:lunch_it/Basket/Model/Meal.dart';
import 'package:lunch_it/Basket/View/BasketEntryCard.dart';
import 'package:lunch_it/Basket/View/PlaceOrderButton.dart';
import 'package:lunch_it/FoodPicker/BottomBar/CashInfoBar.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Consumer<Basket>(builder: (context, basketData, child) {
      return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: basketData.length,
          itemBuilder: (context, index) =>
              basketEntryBuilder(basketData, index),
        ),
        bottomSheet: FractionallySizedBox(
          heightFactor: 1/10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PlaceOrderButton(),
              Expanded(child: CashInfoBar()),
            ],
          ),
        ));
    });
}

Widget basketEntryBuilder(Basket basketData, int index) {
  Meal entry = basketData.getEntry(index);

  return MealCard.modifiable(entry, index, basketData);
}

