import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Routes.dart';

class ShoppingCardButton extends StatelessWidget {
  void _shoppingCartOnPressedCallback(context) =>
    Navigator.of(context).pushNamed(Routes.basketPage);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => _shoppingCartOnPressedCallback(context),
        )
    );
  }
}