import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';
import 'package:lunch_it/FoodPicker/Basket/BasketData.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#MAIL TITLE#"), //TODO dehardcode
      ),
      body: Consumer<BasketData>(builder: (context, basketData, child) {
        return ListView.builder(
          itemCount: basketData.length,
          itemBuilder: (context, index) =>
              basketEntryBuilder(basketData, index),
        );
      }),
    );
  }
}

Widget basketEntryBuilder(BasketData basketData, int index) {
  BasketEntry entry = basketData.getEntry(index);

  return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(entry.foodName),
              Spacer(),
              Text("${entry.price} x ${entry.quantity} = ${entry.price * entry.quantity}")
            ],
          ),
        ],
      )

      //TODO remove button, increase decrease quantity, sum of basket
      );
}
