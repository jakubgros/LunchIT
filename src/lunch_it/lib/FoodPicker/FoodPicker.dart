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


class FoodPicker extends StatelessWidget {

  final VoidCallback _shoppingCartOnPressedCallback = () {}; //TODO implement
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
            body: Provider<MarkerModeEventStream>.value( //TODO use multiprovider
              value: MarkerModeEventStream(),
              child: Provider<AcceptMarkedEventStream>.value(
                value: AcceptMarkedEventStream(),
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
                              child: Menu(
                                contentViewer: WebMenuContentViewer(
                                    url: 'https://www.uszwagra24.pl/menu/'),
                                navbar: NavigationBar(),
                              ),
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
            )));
  }
}

