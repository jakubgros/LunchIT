import 'package:flutter/material.dart';
import 'package:lunch_it/Basket/BasketPage.dart';
import 'package:lunch_it/Basket/BasketData.dart';
import 'package:lunch_it/FoodPicker/OrderAdder/AddMenuPositionPage.dart';
import 'package:lunch_it/FoodPicker/FoodPickerPage.dart';
import 'package:lunch_it/Login/LoginPage.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';
import 'package:lunch_it/SuccessfulOrder.dart';
import 'package:provider/provider.dart';

import 'FoodPicker/Marker/MarkerData.dart';
import 'HomePage/HomePage.dart';
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
        ChangeNotifierProvider<BasketData>(
          builder: (context) => BasketData(),
        ),
        Provider<OrderRequest>(
          builder: (context) => OrderRequest(),
        )
      ],
      child: MaterialApp(
          onGenerateRoute: (RouteSettings settings) {
            String currentRoute = settings.name;
            Object arguments = settings.arguments;

            if(currentRoute == '/'){
              if(ServerApi().areCredentialsSaved()){
                Future<bool> hasGrantedAccess = ServerApi().checkSavedCredentials();
                currentRoute = '/savedCredentialsChecker';
                arguments = hasGrantedAccess;
              }
              else
                currentRoute = '/login';
            }

            var routes = <String, WidgetBuilder> {
              '/foodPicker': (BuildContext context) => FoodPickerPage(arguments),
              '/foodPicker/addMenuPositionPage': (BuildContext context) => AddMenuPositionPage(),
              '/basketPage': (BuildContext context) => BasketPage(),
              '/succesfulOrder': (BuildContext context) => SuccessfulOrder(),
              '/login': (BuildContext context) => LoginPage(onSuccessPath: '/home'),
              '/home': (BuildContext context) => HomePage(),
              '/orderDataPresenter': (BuildContext context) => OrderDataPresenterPage(arguments),
              '/savedCredentialsChecker': (BuildContext context) => SavedCredentialsChecker(arguments),

            };
            WidgetBuilder builder = routes[currentRoute];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
      ),
    );
  }
}

class SavedCredentialsChecker extends StatelessWidget {

  Future<bool> hasGrantedAccessFuture;
  SavedCredentialsChecker(this.hasGrantedAccessFuture);

  bool hasRegisteredCallback = false;
  @override
  Widget build(BuildContext context) {

    if(hasRegisteredCallback == false) {
      hasGrantedAccessFuture.then((hasGranted) {
        if (hasGranted)
          Navigator.of(context).pushNamed('/home');
        else
          Navigator.of(context).pushNamed('/login');
      });
    }

    return Container();
  }
}