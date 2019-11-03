import 'package:flutter/material.dart';

class PlaceOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton.icon(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.all(0.0),
            icon: Icon(Icons.check),
            label: Text("Place order!"),
            color: Colors.green[300],
            onPressed: () {}, //TODO
          ),
        ),
      ],
    );
  }
}
