import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class AddMenuPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            OcrPresenter(File(
                "/data/user/0/com.gros.jakub.lunch_it/cache/selected/food.png")),
            OcrPresenter(File(
                "/data/user/0/com.gros.jakub.lunch_it/cache/selected/price.png")),
          ],
        )
    );
  }
}

class OcrPresenter extends StatelessWidget {
  File _imgFile;

  OcrPresenter(this._imgFile);

  @override
  Widget build(BuildContext context) =>
      Card(
          child: Column(
              children: <Widget>[
                Image.file(_imgFile),
                FutureBuilder<String>(
                    future: ServerApi().getAsText(_imgFile.path),
                    initialData: "xd",
                    builder: (context, snapshot) {
                      print("[DATA] = ${snapshot.data}");
                      return TextFormField(key: ValueKey(snapshot.data), initialValue: snapshot.data);
                    })
              ]
          )
      );
}
