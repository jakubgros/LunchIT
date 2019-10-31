import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';

class BasketData extends ChangeNotifier{
  final data = List<BasketEntry>();

  int get length => data.length;

  BasketEntry getEntry(int index) {
    return data[index];
  }

  void addEntry(BasketEntry newEntry) {
    data.add(newEntry);
    notifyListeners();
  }

  void replaceEntry(BasketEntry entry, int index) {
    data[index] = entry;
    notifyListeners();
  }

  double getSummaryCost() => data.fold(0, (previousVal, elem) => previousVal+elem.quantity*elem.price);
}
