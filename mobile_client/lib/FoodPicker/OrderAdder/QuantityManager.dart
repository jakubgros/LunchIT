

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuantityManager extends StatefulWidget {

  QuantityManager({@required GlobalKey<QuantityManagerState>key}): super(key: key);

  @override
  QuantityManagerState createState() => QuantityManagerState();

}

class QuantityManagerState extends State<QuantityManager> {
  int _quantity = 1;

  int get quantity => _quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Quantity: $_quantity"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: _increaseQuantity,
            ),
            RaisedButton(
              child: Icon(Icons.remove),
              onPressed: _decreaseQuantity,
            ),
          ],
        )
      ],
    );
  }

  void _increaseQuantity() {
    setState(() {
      ++_quantity;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        --_quantity;
      });
    }
  }
}
