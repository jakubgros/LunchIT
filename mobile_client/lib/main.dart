import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/OrderResponseBloc.dart';
import 'package:lunch_it/Bloc/OrderRequestBloc.dart';
import 'package:lunch_it/Pages/AddMealPage.dart';
import 'package:lunch_it/Pages/BasketPage.dart';
import 'package:lunch_it/Pages/FoodPickerPage.dart';
import 'package:lunch_it/Pages/LoginPage.dart';
import 'package:lunch_it/Pages/PlacedOrderPage.dart';
import 'package:lunch_it/Routes.dart';
import 'package:provider/provider.dart';

import 'Bloc/PlacedOrderBloc.dart';
import 'Components/Marker/MarkerData.dart';
import 'Components/ServerApi/ServerApi.dart';
import 'Pages/HomePage.dart';
import 'Pages/RegistrationPage.dart';

void main() => runApp(MyApp());

bool isLoggedIn = false;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarkerData>(
            builder: (context) => MarkerData()
        ),
        Provider<OrderResponseBloc>(
          builder: (context) => OrderResponseBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),
        Provider<OrderRequestBloc> (
          builder: (context) => OrderRequestBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),
        Provider<PlacedOrderBloc> (
          builder: (context) => PlacedOrderBloc(),
          dispose: (context, bloc) => bloc.dispose(),
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
              Routes.orderDataPresenter: (BuildContext context) => PlacedOrderPage(),
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