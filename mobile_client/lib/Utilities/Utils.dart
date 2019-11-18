
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

getOrThrow(Map<String, dynamic> map, Object mapKey) {
  if(map.containsKey(mapKey) == false)
    throw("${mapKey.toString()} field is missing in provided map: \n ${map.toString()}");
  else return map[mapKey];
}

void displayInfoDialog({BuildContext context, String title, String message, VoidCallback onPressOkCallback}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Ok"),
            onPressed: onPressOkCallback,
          ),
        ],
      );
    },
  );
}