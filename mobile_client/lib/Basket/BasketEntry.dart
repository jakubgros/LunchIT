import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lunch_it/Utilities/Utils.dart';

class BasketEntry extends ChangeNotifier { //TODO make all datamodels extend common interface that has toJson, fromJsonString, fromJsonMap
  String _foodName;
  double _price;
  int _quantity;
  String _comment;

  String get foodName => _foodName;
  double get price => _price;
  int get quantity => _quantity;
  String get comment => _comment;

  set foodName(String newVal) {
    _foodName = newVal;
    notifyListeners();
  }

  set price(double newVal) {
    _price = newVal;
    notifyListeners();
  }

  set quantity(int newVal) {
    _quantity = newVal;
    notifyListeners();
  }

  set comment(String newVal) {
    _comment = newVal;
    notifyListeners();
  }

  BasketEntry(this._foodName, this._price, this._quantity, this._comment);

  Map toJson() =>
    {
      "foodName": _foodName,
      "price": _price,
      "quantity": _quantity,
      "comment": _comment,
    };

  BasketEntry.fromJsonString(String json): this.fromJsonMap(jsonDecode(json));

  BasketEntry.fromJsonMap(Map<String, dynamic> parsedJson) {
    _foodName = getOrThrow(parsedJson, "food_name");
    _price = getOrThrow(parsedJson, "price");
    _quantity = getOrThrow(parsedJson, "quantity");
    _comment = getOrThrow(parsedJson, "comment");
  }

}