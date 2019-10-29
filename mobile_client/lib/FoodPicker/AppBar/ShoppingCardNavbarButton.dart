import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShoppingCardNavbarButton extends StatelessWidget {
  VoidCallback _shoppingCartOnPressedCallback = (){}; //TODO

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: _shoppingCartOnPressedCallback,
        )
    );
  }
}