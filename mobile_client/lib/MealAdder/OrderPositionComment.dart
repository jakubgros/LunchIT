import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderComment extends StatelessWidget {
  final void Function(String) onSaved;

  OrderComment({@required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text("Put your comments about the order below: "),
          TextFormField(
            onSaved: onSaved,
            decoration: InputDecoration(border: OutlineInputBorder()),
            maxLines: null,
          ),
        ],
      ),
    );
  }
}

