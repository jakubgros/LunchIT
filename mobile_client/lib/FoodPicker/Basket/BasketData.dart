import 'package:flutter/widgets.dart';

import 'BasketEntry.dart';

class BasketData extends ChangeNotifier{
  final meals = List<BasketEntry>();

  int get length => meals.length;

  BasketEntry getEntry(int index) {
    return meals[index];
  }

  void addEntry(BasketEntry newEntry) {
    newEntry.addListener(() => this.notifyListeners()); //entry changed = notify listeners of whole basket
    meals.add(newEntry);
    notifyListeners(); //basket changed
  }

  void removeEntry(int index) {
    meals.removeAt(index);
    notifyListeners();
  }

  void clear() {
    meals.clear();
    notifyListeners();
  }

  double getSummaryCost() => meals.fold(0, (previousVal, elem) => previousVal+elem.quantity*elem.price);

  Map toJson() =>
    {
      "meals": meals,
    };
}
