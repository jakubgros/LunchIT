import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/foodPicker',
        routes: {
          '/foodPicker': (BuildContext context) => FoodPickerPage(),
        });
  }
}
