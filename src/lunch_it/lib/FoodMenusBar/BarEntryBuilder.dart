import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodMenusBar/BarEntry.dart';

Widget BarEntryBuilder(BuildContext context, int index) //TODO implement
{
  String title = "Menu $index";
  VoidCallback mockedEmptyCallback = () {}; //TODO implement
  return new BarEntry(title: title, onTap: mockedEmptyCallback);
}
