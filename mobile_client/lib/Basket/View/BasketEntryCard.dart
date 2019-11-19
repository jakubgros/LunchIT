
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Basket/Model/Basket.dart';
import 'package:lunch_it/Basket/Model/Meal.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';
import 'package:lunch_it/Page/HomePage.dart';
import 'package:lunch_it/Utilities/Widgets/BoldText.dart';


class MealCard extends StatelessWidget {
  final Meal meal;
  Basket basket;
  final bool _isModifiable;
  int index;

  MealCard.modifiable(this.meal, this.index, this.basket):
      _isModifiable = true;

  MealCard.presenter(this.meal): //TODO do sth about impl
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
                  BoldText(meal.name),
                  Text("${meal.price} x ${meal.quantity} = ${meal.price *
                      meal.quantity}")
                ],
              ),
              if(meal.comment != null) Text("(${meal.comment})"),
              if (_isModifiable == true) Column(
                children: <Widget>[
                  Divider(color: Colors.black),
                  Row(
                    children: <Widget>[
                      QuantityManager(
                        initVal: meal.quantity,
                        onChanged: (int quantity) => meal.quantity = quantity,
                      ),
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.remove),
                        color: Colors.red[300],
                        onPressed: () => basket.removeEntry(index),
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