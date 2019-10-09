import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodMenusBar/FoodMenusBarEntry.dart';

Widget FoodMenusBarEntryBuilder(BuildContext context, int index) //TODO implement
{
  String title = "Menu $index";
  VoidCallback mockedEmptyCallback = () {};
  return new FoodMenusBarEntry(title, mockedEmptyCallback);
}
