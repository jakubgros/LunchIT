import 'dart:async';

import 'package:flutter/material.dart';

import 'BottomMenuBar.dart';
import 'FoodMenusBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'mark_mode_bloc.dart';
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

class InheritedMarkModeBloc extends InheritedWidget
{

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {

  }
}

class VerticalLayout extends StatelessWidget {
  MarkModeBloc _markModeBloc;

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
            body: BlocProvider<MarkModeBloc>(
              bloc: MarkModeBloc(),
              child: Column(
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
              ),
            )
            ));
  }
}

class WebMenuContentViewer extends StatefulWidget {
  final String _webUrl;

  WebMenuContentViewer(this._webUrl);

  @override
  _WebMenuContentViewerState createState() => _WebMenuContentViewerState();
}

class _WebMenuContentViewerState extends State<WebMenuContentViewer> {
  MarkModeBloc _bloc;
  
  Completer<WebViewController> _controller = Completer<WebViewController>();

  void _goBackCallback()
  {
    _controller.future.then((controller){controller.goBack();});
  }

  void _goForwardCallback()
  {
    _controller.future.then((controller){controller.goForward();});
  }

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
              child: StreamBuilder(
                stream: _bloc.state,
                initialData: MarkModeState.navigateMode(),
                builder: (BuildContext context, AsyncSnapshot<MarkModeState>snapshot) {
                  print(snapshot.data.isFoodMode());
                  print(snapshot.data.isNavigateMode());
                  print(snapshot.data.isPriceMode());
                  print("@@@");
                  return WebView(
                    initialUrl: widget._webUrl,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },);
                }
              ),
            ),
          )

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
  }
}

