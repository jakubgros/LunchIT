
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class MarkerData extends ChangeNotifier{
  File _markedFood;
  File _markedPrice;

  void addFood(File foodImage) {
    _markedFood = foodImage;
    notifyListeners();
  }

  void addPrice(File priceImage) {
    _markedPrice = priceImage;
    notifyListeners();
  }

  void reset() {
    _markedFood = null;
    _markedPrice = null;
  }

  bool get hasFoodData => _markedFood != null;
  bool get hasPriceData => _markedPrice != null;


  Image get foodImg => Image.file(_markedFood);
  Image get priceImg => Image.file(_markedPrice);

  Future<String> get foodAsText => ServerApi().getAsText(_markedFood.path);
  Future<String> get priceAsText => ServerApi().getAsText(_markedPrice.path);

}