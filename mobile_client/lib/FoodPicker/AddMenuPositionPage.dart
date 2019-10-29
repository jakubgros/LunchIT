import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardAppbarButton.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class AddMenuPositionPage extends StatefulWidget {
  @override
  _AddMenuPositionPageState createState() => _AddMenuPositionPageState();
}

class _AddMenuPositionPageState extends State<AddMenuPositionPage> {
  int _quantity = 1;
  TextEditingController _commentTextFieldController = TextEditingController();
  TextEditingController _foodTextFieldController = TextEditingController();
  final _formState = GlobalKey<FormState>();

  TextEditingController _priceTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ShoppingCardAppbarButton(),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: _formState,
              child: Column(
                children: <Widget>[
                  OcrPresenter(
                    image: File(
                        "/data/user/0/com.gros.jakub.lunch_it/cache/selected/food.png"),
                    textController: _foodTextFieldController,
                    validator: _foodValidator,
                  ),
                  OcrPresenter(
                    image: File(
                        "/data/user/0/com.gros.jakub.lunch_it/cache/selected/price.png"),
                    textController: _priceTextFieldController,
                    validator: _priceValidator,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text("Put your comments about the order below: "),
                        TextField(
                          controller: _commentTextFieldController,
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
            ),
          ],
        ));
  }

  void _addToBasket(context) {
    if(!_formState.currentState.validate())
      return;

    String comment = _commentTextFieldController.text;
    String foodAsText = _foodTextFieldController.text;
    String priceAsText = _priceTextFieldController.text;

    Navigator.of(context).pop();
    // TODO Implement adding to basket
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

  String _foodValidator(String value) {
    if(value.isEmpty)
      return "The field can't  be empty!";
    else 
      return null;
  }

  String _priceValidator(String value) {
    var priceRegexp = RegExp(r'[0-9]+([,.][0-9]{1,2})?\s*((zl)|(zł)|(ZŁ)|(ZL)|(PLN)|(pln))?');

    if(value.isEmpty)
      return "The field can't  be empty!";
    else if(!priceRegexp.hasMatch(value))
      return "the entered value is not a price";
    else
      return null;
  }
}

class OcrPresenter extends StatelessWidget {
  File _imgFile;
  TextEditingController _textController;
  FormFieldValidator<String> _validator;
  GlobalKey<FormState> _formState;

  OcrPresenter(
      {@required File image,
      @required TextEditingController textController,
      FormFieldValidator<String> validator,})
      : _imgFile = image,
        _textController = textController,
        _validator = validator;

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
                  _textController.text = snapshot.data;

                  return TextFormField(
                    key: ValueKey(snapshot.data),
                    controller: _textController,
                    maxLines: null,
                    validator: _validator,
                  );
                })
          ]),
        ),
      );
}
