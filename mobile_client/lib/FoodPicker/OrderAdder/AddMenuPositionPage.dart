import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/Basket/Model/Basket.dart';
import 'package:lunch_it/Basket/Model/Meal.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardAppbarButton.dart';
import 'package:lunch_it/FoodPicker/Marker/MarkerData.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/OcrPresenterAndCorrecter.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/OrderPositionComment.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/QuantityManager.dart';
import 'package:lunch_it/Utilities/Validator.dart';
import 'package:provider/provider.dart';

class AddMenuPositionPage extends StatefulWidget {
  AddMenuPositionPage();

  @override
  _AddMenuPositionPageState createState() => _AddMenuPositionPageState();
}

class _AddMenuPositionPageState extends State<AddMenuPositionPage> {
  final _formState = GlobalKey<FormState>();

  String _foodAsText;
  String _priceAsText;
  String _comment;
  int _quantity;

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
              child: Consumer<MarkerData>(
                builder: (context, markerData, child) =>
                Column(
                  children: <Widget>[
                    OcrPresenterAndCorrecter(
                      image: markerData.foodImg,
                      imageAsText: markerData.foodAsText,
                      onSaved: (String value) => _foodAsText = value,
                      validator: _foodValidator,
                    ),
                    OcrPresenterAndCorrecter(
                      image: markerData.priceImg,
                      imageAsText: markerData.priceAsText,
                      onSaved: (String value) => _priceAsText = value,
                      validator: _priceValidator,
                    ),
                    OrderComment(onSaved: (String value) => _comment = value),
                    QuantityManager(onSaved: (String value) => _quantity = int.parse(value)),
                    RaisedButton(
                      child: Text("Add to basket"),
                      onPressed: () => _addToBasket(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  static double _convertPriceToDouble(String price) {
    price = price.replaceAll(",", ".");
    final notNumberOrFractionalSeparator = RegExp("[^0-9.]+");
    price = price.replaceAll(notNumberOrFractionalSeparator, "");
    price = price.replaceAll(" ", "");
    return double.parse(price);
  }

  void _addToBasket(context) {
    if (!_formState.currentState.validate()) return;

    _formState.currentState.save();

    double price = _convertPriceToDouble(_priceAsText);

    if(_comment.trim() == "")
      _comment = null;

    var newEntry = Meal(_foodAsText, price, _quantity, _comment);

    Provider.of<Basket>(context, listen: false).addEntry(newEntry);

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
    if (value.isEmpty)
      return "The field can't  be empty!";
    else if (!Validator.isPrice(value))
      return "the entered value is not a price";
    else
      return null;
  }
}
