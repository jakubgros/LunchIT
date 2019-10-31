import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShoppingCardAppbarButton extends StatelessWidget {
  void _shoppingCartOnPressedCallback(context) =>
    Navigator.of(context).pushNamed('/basketPage');

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