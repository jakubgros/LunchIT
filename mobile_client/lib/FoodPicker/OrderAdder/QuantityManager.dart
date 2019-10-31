import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuantityManager extends StatefulWidget {
  final void Function(int) onChanged;

  QuantityManager({@required this.onChanged});

  @override
  QuantityManagerState createState() => QuantityManagerState();
}

class QuantityManagerState extends State<QuantityManager> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();

    widget.onChanged(_quantity); //to pass initial value
  }

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
      widget.onChanged(++_quantity);
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        widget.onChanged(--_quantity);
      });
    }
  }
}
