import 'package:flutter/material.dart';
import 'package:lunch_it/Appbar/ShoppingCardButton.dart';
import 'package:lunch_it/Bar/CashInfoBar.dart';
import 'package:lunch_it/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/EventStreams/MarkerMode.dart';
import 'package:lunch_it/EventStreams/WebNavigation.dart';
import 'package:lunch_it/FoodPicker/BottomBar/OrderingTools.dart';
import 'package:lunch_it/OrderRequest/OrderRequestModel.dart';
import 'package:provider/provider.dart';

import '../FoodPicker/MenuViewer/Menu.dart';
import '../FoodPicker/MenuViewer/WebMenu/NavigationBar.dart';
import '../FoodPicker/MenuViewer/WebMenu/WebMenuContentViewer.dart';

class FoodPickerPage extends StatefulWidget {
  final OrderRequest orderRequest;

  FoodPickerPage(this.orderRequest);

  @override
  _FoodPickerPageState createState() => _FoodPickerPageState();
}

class _FoodPickerPageState extends State<FoodPickerPage> {
  Menu _menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          ShoppingCardButton(),
        ],
        title: Text(widget.orderRequest.title),
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
                      builder: (context) => WebNavigationEventStream(),
                      dispose: (context, value) => value.close(),
                      child: _menu,
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: OrderingTools(),
                        ),
                        Expanded(
                            flex: 1,
                            child: CashInfoBar()
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _menu = Menu(
      contentViewer: WebMenuContentViewer(url: widget.orderRequest.menuUrl),
      navbar: NavigationBar(),
    );
  }
}
