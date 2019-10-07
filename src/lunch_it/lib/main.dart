import 'package:flutter/material.dart';

import 'BottomMenuBar.dart';
import 'FoodMenusBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? VerticalLayout()
          : HorizontalLayout();
    });
  }
}

class HorizontalLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: Text("Not implemented") //TODO implement
            ));
  }
}

class VerticalLayout extends StatelessWidget {
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
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FoodMenusBar(2), //TODO dehardcode
                    ],
                  ),
                ),
                Expanded(
                  flex: 18,
                  child: Row(
                    children: <Widget>[
                      WebMenuContentViewer('https://uszwagra24.pl/menu/'),
                    ],
                  )
                ),
                Expanded(
                  flex:2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      BottomMenuBar(),
                    ],
                  ),
                ),
              ],
            )
            ));
  }
}

class WebMenuContentViewer extends StatelessWidget {

  final String _webUrl;

  WebMenuContentViewer(this._webUrl);

  WebViewController _controller;
  VoidCallback _goBackCallback = (){}; //TODO
  VoidCallback _goForwardCallback = (){}; //TODO

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _goBackCallback,
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _goForwardCallback,
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 1000,
              width: 1000,
              child: WebView(
                initialUrl: _webUrl,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },),
            ),
          )

        ],
      ),
    );
  }

}