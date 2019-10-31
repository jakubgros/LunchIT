
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class MarkerData extends ChangeNotifier{
  File _markedFood;
  Image _markedFoodImg;
  Future<String> _foodAsText;

  File _markedPrice;
  Image _markedPriceImg;
  Future<String> _priceAsText;

  void addFood(File foodImage) {
    resetFood();

    _markedFood = foodImage;
    _markedFoodImg = Image.file(_markedFood);
    _foodAsText = ServerApi().getAsText(_markedFood);

    notifyListeners();
  }

  void addPrice(File priceImage) {
    resetPrice();

    _markedPrice = priceImage;
    _markedPriceImg = Image.file(_markedPrice);
    _priceAsText = ServerApi().getAsText(_markedPrice);

    notifyListeners();
  }

  void reset() {
    resetFood();
    resetPrice();
  }
  void resetPrice() {
    _markedPrice?.delete();

    _markedPrice = null;
    _markedPriceImg = null;
    _priceAsText = null;
  }

  void resetFood() {
    _markedFood?.delete();

    _markedFood = null;
    _markedFoodImg = null;
    _foodAsText = null;
  }

  bool get hasFoodData => _markedFood != null;
  bool get hasPriceData => _markedPrice != null;


  Image get foodImg => _markedFoodImg;
  Image get priceImg => _markedPriceImg;

  Future<String> get foodAsText => _foodAsText;
  Future<String> get priceAsText => _priceAsText;
}