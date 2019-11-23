import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/OrderRequestBloc.dart';
import 'package:lunch_it/Pages/AddMealPage.dart';
import 'package:lunch_it/Pages/BasketPage.dart';
import 'package:lunch_it/Pages/FoodPickerPage.dart';
import 'package:lunch_it/Pages/LoginPage.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/Pages/OrderResponsePage.dart';
import 'package:lunch_it/Routes.dart';
import 'package:provider/provider.dart';

import 'Components/Marker/MarkerData.dart';
import 'Components/ServerApi/ServerApi.dart';
import 'DataModels/BasketModel.dart';
import 'Pages/HomePage.dart';
import 'Pages/RegistrationPage.dart';

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
        ChangeNotifierProvider<BasketModel>(
          builder: (context) => BasketModel(),
        ),
        Provider<OrderRequestModel>(
          builder: (context) => OrderRequestModel(),
        ),
        Provider<OrderRequestBloc> (
          builder: (context) => OrderRequestBloc(),
        )
      ],
      child: MaterialApp(
          onGenerateRoute: (RouteSettings settings) {
            String currentRoute = settings.name;

            var routes = <String, WidgetBuilder> {
              Routes.foodPicker: (BuildContext context) => FoodPickerPage(settings.arguments),
              Routes.addMenuPositionPage: (BuildContext context) => AddMealPage(),
              Routes.basketPage: (BuildContext context) => BasketPage(),
              Routes.login: (BuildContext context) => LoginPage(onSuccessPath: Routes.home),
              Routes.register: (BuildContext context) => RegistrationPage(),
              Routes.home: (BuildContext context) => HomePage(),
              Routes.orderDataPresenter: (BuildContext context) => OrderResponsePage(settings.arguments),
              Routes.initialRoute: (BuildContext context) => SavedCredentialsChecker(),

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
        navigator.pushNamed(Routes.home);
      else
        navigator.pushNamed(Routes.login);
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