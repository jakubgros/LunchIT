import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Routes.dart';

class ShoppingCardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.of(context).pushNamed(Routes.basketPage),
        )
    );
  }
}