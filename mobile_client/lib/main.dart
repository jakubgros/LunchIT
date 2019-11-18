import 'package:flutter/material.dart';
import 'package:lunch_it/Page/BasketPage.dart';
import 'package:lunch_it/Basket/Model/Basket.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';
import 'package:lunch_it/Login/LoginPage.dart';
import 'package:lunch_it/Models/OrderRequestModel.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';
import 'package:lunch_it/SuccessfulOrder.dart';
import 'package:provider/provider.dart';

import 'FoodPicker/Marker/MarkerData.dart';
import 'HomePage/HomePage.dart';
import 'Login/RegistrationPage.dart';
import 'OrderDataPresenter/OrderDataPresenterPage.dart';

void main() => runApp(MyApp());

bool isLoggedIn = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarkerData>(
            builder: (context) => MarkerData()
        ),
        ChangeNotifierProvider<Basket>(
          builder: (context) => Basket(),
        ),
        Provider<OrderRequest>(
          builder: (context) => OrderRequest(),
        )
      ],
      child: MaterialApp(
          onGenerateRoute: (RouteSettings settings) {
            String currentRoute = settings.name;

            var routes = <String, WidgetBuilder> {
              '/foodPicker': (BuildContext context) => FoodPickerPage(settings.arguments),
              '/foodPicker/addMenuPositionPage': (BuildContext context) => AddMenuPositionPage(),
              '/basketPage': (BuildContext context) => BasketPage(),
              '/succesfulOrder': (BuildContext context) => SuccessfulOrder(),
              '/login': (BuildContext context) => LoginPage(onSuccessPath: '/home'),
              '/register': (BuildContext context) => RegistrationPage(),
              '/home': (BuildContext context) => HomePage(),
              '/orderDataPresenter': (BuildContext context) => OrderDataPresenterPage(settings.arguments),
              '/': (BuildContext context) => SavedCredentialsChecker(),

            };
            WidgetBuilder builder = routes[currentRoute];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
      ),
    );
  }
}


bool hasRegisteredCallback = false;
class SavedCredentialsChecker extends StatelessWidget {

  void _registerCallback(NavigatorState navigator) async{

      bool hasGrantedAccess = await ServerApi().checkSavedCredentials();
      if(hasGrantedAccess)
        navigator.pushNamed('/home');
      else
        navigator.pushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {

    if(hasRegisteredCallback == false) {
      _registerCallback(Navigator.of(context));
      hasRegisteredCallback = true;
    }

    return Container();
  }
}