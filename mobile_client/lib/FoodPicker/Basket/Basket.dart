import 'package:flutter/cupertino.dart';

class BasketEntry extends ChangeNotifier {
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
}