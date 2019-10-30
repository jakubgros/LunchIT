
import 'dart:io';

class MarkerData {
  File _markedFood;
  File _markedPrice;

  void addFood(File foodImage) => _markedFood = foodImage;
  void addPrice(File priceImage) => _markedPrice = priceImage;

  void reset() {
    _markedFood = null;
    _markedPrice = null;
  }

  bool get hasFoodData => _markedFood != null;
  bool get hasPriceData => _markedPrice != null;

  File get food => _markedFood;
  File get price => _markedPrice;
}