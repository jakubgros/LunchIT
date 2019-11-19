import 'package:flutter/widgets.dart';
import 'MealModel.dart';

class BasketModel extends ChangeNotifier{
  final meals = List<MealModel>();

  MealModel getEntry(int index) {
    return meals[index];
  }

  void addEntry(MealModel newEntry) {
    newEntry.addListener(() => this.notifyListeners()); //entry changed - notify listeners of whole basket
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

  int get length => meals.length;

  Map toJson() => {
      "meals": meals,
    };
}
