import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Button/LabeledIconButton.dart';
import 'package:lunch_it/Routes.dart';

class ShoppingCardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LabeledIconButton(
      label: Text("Basket"),
      icon: Icon(Icons.shopping_cart),
      onPressed: () => Navigator.of(context).pushNamed(Routes.basketPage),
    );
  }
}
