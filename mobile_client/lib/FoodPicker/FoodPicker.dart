import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/FoodPicker/EventStreams/MarkerMode.dart';
import 'package:lunch_it/FoodPicker/EventStreams/WebNavigation.dart';
import 'package:provider/provider.dart';

import 'BottomBar/BottomMenu.dart';
import 'FoodMenusBar/FoodMenusBar.dart';
import 'MenuViewer/Menu.dart';
import 'MenuViewer/WebMenu/NavigationBar.dart';
import 'MenuViewer/WebMenu/WebMenuContentViewer.dart';

class FoodPicker extends StatefulWidget {
  @override
  _FoodPickerState createState() => _FoodPickerState();
}

class _FoodPickerState extends State<FoodPicker> {


  final VoidCallback _shoppingCartOnPressedCallback = () {};

  Menu _menu;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: _shoppingCartOnPressedCallback,
              ),
            )
          ],
          title: Text("#MAIL TITLE#"), //TODO dehardcode
          leading: BackButton(),
        ),
        body: MultiProvider(
          providers: [
            Provider<MarkerModeEventStream>.value(
                value: MarkerModeEventStream()),
            Provider<AcceptMarkedEventStream>.value(
              value: AcceptMarkedEventStream(),
            )
          ],
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FoodMenusBar(
                        amountOfEntries: 2,
                        listColor: Colors.blue[300],
                        separatorColor: Colors.black),
                  ],
                ),
              ),
              Expanded(
                  flex: 18,
                  child: Row(
                    children: <Widget>[
                      Provider<WebNavigationEventStream>.value(
                        value: WebNavigationEventStream(),
                        //TODO cancel streams subscriptions on dispose
                        child: _menu,
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    BottomMenu(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _menu = Menu(
      contentViewer: WebMenuContentViewer(
          url: 'https://www.uszwagra24.pl/menu/'),
      navbar: NavigationBar(),
    );
  }
}
