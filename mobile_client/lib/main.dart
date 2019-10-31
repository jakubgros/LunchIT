import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';
import 'package:provider/provider.dart';

import 'FoodPicker/Marker/MarkerData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarkerData>(
            builder: (context) => MarkerData()
        )
      ],
      child: MaterialApp(
          initialRoute: '/foodPicker',
          routes: {
            '/foodPicker': (BuildContext context) => FoodPickerPage(),
            '/foodPicker/addMenuPositionPage': (BuildContext context) => AddMenuPositionPage(),
          }),
    );
  }
}
