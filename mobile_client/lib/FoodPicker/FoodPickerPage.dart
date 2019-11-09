import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/AppBar/ShoppingCardAppbarButton.dart';
import 'package:lunch_it/FoodPicker/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/FoodPicker/EventStreams/MarkerMode.dart';
import 'package:lunch_it/FoodPicker/EventStreams/WebNavigation.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:provider/provider.dart';

import 'BottomBar/BottomMenu.dart';
import 'MenuViewer/Menu.dart';
import 'MenuViewer/WebMenu/NavigationBar.dart';
import 'MenuViewer/WebMenu/WebMenuContentViewer.dart';

class FoodPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderRequest orderRequest = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ShoppingCardAppbarButton(),
          ],
          title: Text(orderRequest.title),
          leading: BackButton(),
        ),
        body: MultiProvider(
          providers: [
              Provider<MarkerModeEventStream>(
                builder: (context) => MarkerModeEventStream(),
                dispose: (context, value) => value.close(),
              ),
              Provider<AcceptMarkedEventStream>(
                builder: (context) => AcceptMarkedEventStream(),
                dispose: (context, value) => value.close(),
              ),
          ],
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 18,
                    child: Row(
                      children: <Widget>[
                        Provider<WebNavigationEventStream>(
                          builder: (context)=> WebNavigationEventStream(),
                          dispose: (context, value) => value.close(),
                          child: Menu(
                            contentViewer: WebMenuContentViewer(
                                url: orderRequest.menuUrl),
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
        );
  }
}
