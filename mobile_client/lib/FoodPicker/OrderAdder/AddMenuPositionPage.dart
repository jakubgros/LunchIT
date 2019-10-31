import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardAppbarButton.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';
import 'package:lunch_it/FoodPicker/Marker/MarkerData.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/OcrPresenter.dart';
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
  final _quantityManagerKey = GlobalKey<QuantityManagerState>();

  String _foodAsText = "";
  String _priceAsText = "";
  String _comment = "";

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
                    OcrPresenterCorrecter(
                      image: markerData.foodImg,
                      text: markerData.foodAsText,
                      onValueChanged: (String ocr) => _foodAsText = ocr,
                      validator: _foodValidator,
                    ),
                    OcrPresenterCorrecter(
                      image: markerData.priceImg,
                      text: markerData.priceAsText,
                      onValueChanged: (String ocr) => _priceAsText = ocr,
                      validator: _priceValidator,
                    ),
                    OrderComment(onChanged: (String comment) => _comment = comment),
                    QuantityManager(key: _quantityManagerKey),
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
    double price = _convertPriceToDouble(_priceAsText);
    int quantity = _quantityManagerKey.currentState.quantity;

    var newEntry = BasketEntry(_foodAsText, price, quantity, _comment);

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
    if (value.isEmpty)
      return "The field can't  be empty!";
    else if (!Validator.isPrice(value))
      return "the entered value is not a price";
    else
      return null;
  }
}
