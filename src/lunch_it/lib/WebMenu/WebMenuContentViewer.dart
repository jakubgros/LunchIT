import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBloc.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBlocEvent.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBlocState.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Coverer.dart';
import 'WebMenuContentViewerBar.dart';

class MenuViewer extends StatefulWidget {

  Widget _menuContentViewer;
  Widget _menuContentViewerBar;

  MenuViewer(this._menuContentViewer,
      this._menuContentViewerBar);

  @override
  _MenuViewerState createState() => _MenuViewerState();
}

class _MenuViewerState extends State<MenuViewer> {
  MarkModeBloc _bloc;

  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: StreamBuilder(
          stream: _bloc.state,
          initialData: MarkModeState.navigateMode(),
          builder:
              (BuildContext context, AsyncSnapshot<MarkModeState> snapshot) {
            return Column(
              children: <Widget>[
                Flexible(
                  child: widget._menuContentViewerBar,
                  flex: 1,
                ),
                Flexible(
                  flex: 14,
                  child: Stack(
                    children: <Widget>[
                      Visibility(
                        child: widget._menuContentViewer,
                        visible: true,
                        maintainState: true,),
                      Coverer(snapshot.data.isNavigateMode() == false),
                      Visibility(
                        visible: snapshot.data.isNavigateMode() == false,
                        child: Placeholder(),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
  }
}


class WebMenuContentViewer extends StatefulWidget {
  String _webUrl;

  WebMenuContentViewer(this._webUrl);

  @override
  _WebMenuContentViewerState createState() => _WebMenuContentViewerState();
}

class _WebMenuContentViewerState extends State<WebMenuContentViewer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NavbarBlocState>(
      stream: BlocProvider.of<NavbarBloc>(context).state,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          if(snapshot.data.isGoBack())
            _controller.future.then((controller) => controller.goBack());
          if(snapshot.data.isGoForward())
            _controller.future.then((controller) => controller.goForward());
        }

        return WebView(
          initialUrl: widget._webUrl,
          onWebViewCreated:
              (WebViewController webViewController) {
            if (_controller.isCompleted == false)
              _controller.complete(webViewController);
          },
        );
      }
    );
  }
}

