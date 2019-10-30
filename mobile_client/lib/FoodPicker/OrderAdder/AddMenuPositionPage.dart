import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardAppbarButton.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/OcrPresenter.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/OrderPositionComment.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';

class AddMenuPositionPage extends StatefulWidget {
  final Image _foodImage;
  final Future<String> _foodAsText;
  final Image _priceImage;
  final Future<String> _priceAsText;

  AddMenuPositionPage(
      {@required Image foodAsImg,
      @required Future<String> foodAsText,
      @required Image priceAsImg,
      @required Future<String> priceAsText})
      : _foodImage = foodAsImg,
        _priceImage = priceAsImg,
        _foodAsText = foodAsText,
        _priceAsText = priceAsText;

  @override
  _AddMenuPositionPageState createState() => _AddMenuPositionPageState();
}

class _AddMenuPositionPageState extends State<AddMenuPositionPage> {
  final _commentController = TextEditingController();
  final _formState = GlobalKey<FormState>();
  final _quantityManagerKey = GlobalKey<QuantityManagerState>();

  OcrPresenterCorrecter _food;
  OcrPresenterCorrecter _price;

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
                  _food = OcrPresenterCorrecter(
                    image: widget._foodImage, //TODO image is not replaced if I go back from this page, mark it once again and click add
                    text: widget._foodAsText,
                    validator: _foodValidator,
                  ),
                  _price = OcrPresenterCorrecter(
                    image: widget._priceImage,
                    text: widget._priceAsText,
                    validator: _priceValidator,
                  ),
                  OrdersPositionComment(_commentController),
                  QuantityManager(key: _quantityManagerKey),
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

  static double _convertPriceToDouble(String price) {
    price = price.replaceAll(",", ".");
    final letter = RegExp("[a-zA-Z]+");
    price = price.replaceAll(letter, "");
    price = price.replaceAll(" ", "");
    return double.parse(price);
  }

  void _addToBasket(context) {
    if (!_formState.currentState.validate()) return;

    String foodAsText = _food.value;
    double price = _convertPriceToDouble(_price.value);
    String comment = _commentController.text;
    int quantity = _quantityManagerKey.currentState.quantity;

    var newEntry = BasketEntry(foodAsText, price, quantity, comment);

    //TODO add the entry to basket

    Navigator.of(context).pop(
        true); //true means that element has been successfully added to the basket
  }

  static String _foodValidator(String value) {
    if (value.isEmpty)
      return "The field can't  be empty!";
    else
      return null;
  }

  static String _priceValidator(String value) {
    var priceRegexp =
        RegExp(r'[0-9]+([,.][0-9]{1,2})?\s*((zl)|(zł)|(ZŁ)|(ZL)|(PLN)|(pln))?');

    if (value.isEmpty)
      return "The field can't  be empty!";
    else if (!priceRegexp.hasMatch(value))
      return "the entered value is not a price";
    else
      return null;
  }
}
