
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrdersPositionComment extends StatelessWidget {
  final TextEditingController _textFieldController;

  OrdersPositionComment(this._textFieldController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text("Put your comments about the order below: "),
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(border: OutlineInputBorder()),
            maxLines: null,
          ),
        ],
      ),
    );
  }
}

