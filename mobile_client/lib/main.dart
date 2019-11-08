import 'package:flutter/material.dart';
import 'package:lunch_it/Basket/BasketPage.dart';
import 'package:lunch_it/Basket/BasketData.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';
import 'package:lunch_it/Login/LoginPage.dart';
import 'package:lunch_it/SuccessfulOrder.dart';
import 'package:provider/provider.dart';

import 'FoodPicker/Marker/MarkerData.dart';
import 'HomePage/HomePage.dart';
import 'OrderDataPresenter/OrderDataPresenterPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarkerData>(
            builder: (context) => MarkerData()
        ),
        ChangeNotifierProvider<BasketData>(
          builder: (context) => BasketData(),
        )
      ],
      child: MaterialApp(
          initialRoute: '/home', //TODO change to login
          routes: {
            '/foodPicker': (BuildContext context) => FoodPickerPage(),
            '/foodPicker/addMenuPositionPage': (BuildContext context) => AddMenuPositionPage(),
            '/basketPage': (BuildContext context) => BasketPage(),
            '/succesfulOrder': (BuildContext context) => SuccessfulOrder(),
            '/login': (BuildContext context) => LoginPage(onSuccessPath: '/home'),
            '/home': (BuildContext context) => HomePage(),
            '/orderDataPresenter': (BuildContext context) => OrderDataPresenterPage(),
          }),
    );
  }
}
