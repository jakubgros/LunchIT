import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardNavbarButton.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class AddMenuPositionPage extends StatefulWidget {
  @override
  _AddMenuPositionPageState createState() => _AddMenuPositionPageState();
}



class _AddMenuPositionPageState extends State<AddMenuPositionPage> {
  int _quantity = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ShoppingCardNavbarButton(),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                OcrPresenter(File(
                    "/data/user/0/com.gros.jakub.lunch_it/cache/selected/food.png")),
                OcrPresenter(File(
                    "/data/user/0/com.gros.jakub.lunch_it/cache/selected/price.png")),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text("Put your comments about the order below: "),
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
                Text("Quantity: ${_quantity}"),
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
                ),
                RaisedButton(
                  child: Text("Add to basket"),
                  onPressed: () => _addToBasket(context),
                ),
              ],
            ),
          ],
        ));
  }

  void _addToBasket(context) {
    Navigator.of(context).pop();
    // TODO Implement adding to basket
  }

  void _increaseQuantity() {
    setState(() {
      ++_quantity;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        --_quantity;
      });
    }
  }
}

class OcrPresenter extends StatelessWidget {
  File _imgFile;

  OcrPresenter(this._imgFile);

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[300],
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Image.file(
              _imgFile,
              fit: BoxFit.scaleDown,
            ),
            FutureBuilder<String>(
                future: ServerApi().getAsText(_imgFile.path),
                initialData: "",
                builder: (context, snapshot) {
                  return TextFormField(
                    key: ValueKey(snapshot.data),
                    initialValue: snapshot.data,
                    maxLines: null,
                  );
                })
          ]),
        ),
      );
}
