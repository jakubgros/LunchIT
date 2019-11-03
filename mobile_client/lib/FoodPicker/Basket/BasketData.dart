import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Basket/Basket.dart';

class BasketData extends ChangeNotifier{
  final data = List<BasketEntry>();

  int get length => data.length;

  BasketEntry getEntry(int index) {
    return data[index];
  }

  void addEntry(BasketEntry newEntry) {
    newEntry.addListener(() => this.notifyListeners()); //entry changed = notify listeners of whole basket
    data.add(newEntry);
    notifyListeners(); //basket changed
  }

  void removeEntry(int index) {
    data.removeAt(index);
    notifyListeners();
  }

  double getSummaryCost() => data.fold(0, (previousVal, elem) => previousVal+elem.quantity*elem.price);
}
