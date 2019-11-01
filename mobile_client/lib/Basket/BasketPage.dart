import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';
import 'package:lunch_it/FoodPicker/Basket/BasketData.dart';
import 'package:lunch_it/FoodPicker/BottomBar/CashInfoBar.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';
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
      //bottomSheet: CashInfoBar(12.34, 56.78),
    );
  }
}

Widget basketEntryBuilder(BasketData basketData, int index) {
  BasketEntry entry = basketData.getEntry(index);

  return Card(
    color: Colors.grey[250],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(entry.foodName),
                Spacer(),
                Text("${entry.price} x ${entry.quantity} = ${entry.price * entry.quantity}")
              ],
            ),
            QuantityManager(),
            FlatButton(
              child: Icon(Icons.remove),
              color: Colors.red[300],
              onPressed: () {},//TODO remove entry
            )
          ],
        ),
      )

      //TODO remove button, increase decrease quantity, sum of basket
      );
}
