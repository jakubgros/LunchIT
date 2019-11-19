import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabeledTextForm extends StatelessWidget {
  final void Function(String) onSaved;
  final String label;
  LabeledTextForm({@required this.onSaved, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(label),
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

