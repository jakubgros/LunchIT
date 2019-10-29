import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/foodPicker/addMenuPosition', //TODO change back to '/foodPicker'
        routes: {
          '/foodPicker': (BuildContext context) => FoodPickerPage(),
          '/foodPicker/addMenuPosition': (BuildContext context) => AddMenuPositionPage(),
        });
  }
}
