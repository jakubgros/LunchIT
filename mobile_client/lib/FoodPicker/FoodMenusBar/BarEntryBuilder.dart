import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/FoodMenusBar/BarEntry.dart';

Widget barEntryBuilder(BuildContext context, int index) //TODO implement
{
  String title = "Menu $index";
  VoidCallback mockedEmptyCallback = () {}; //TODO implement
  return new BarEntry(title: title, onTap: mockedEmptyCallback);
}
