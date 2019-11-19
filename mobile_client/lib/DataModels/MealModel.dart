import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lunch_it/Utilities/Utils.dart';

class MealModel extends ChangeNotifier {
  MealModel(this._name, this._price, this._quantity, this._comment);

  String _name;
  double _price;
  int _quantity;
  String _comment;

  String get name => _name;

  double get price => _price;

  int get quantity => _quantity;

  String get comment => _comment;

  set name(String newVal) {
    _name = newVal;
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

  Map toJson() => {
        "foodName": _name,
        "price": _price,
        "quantity": _quantity,
        "comment": _comment,
      };

  MealModel.fromJsonString(String json) : this.fromJsonMap(jsonDecode(json));

  MealModel.fromJsonMap(Map<String, dynamic> parsedJson) {
    _name = getOrThrow(parsedJson, "food_name");
    _price = getOrThrow(parsedJson, "price");
    _quantity = getOrThrow(parsedJson, "quantity");
    _comment = getOrThrow(parsedJson, "comment");
  }
}
