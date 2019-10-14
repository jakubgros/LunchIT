import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Coverer.dart';
import 'WebMenuContentViewerBar.dart';

class WebMenuContentViewer extends StatefulWidget {
  final String _webUrl;

  WebMenuContentViewer(this._webUrl);

  @override
  _WebMenuContentViewerState createState() => _WebMenuContentViewerState();
}

class _WebMenuContentViewerState extends State<WebMenuContentViewer> {
  MarkModeBloc _bloc;
  String _lastUrl;

  Completer<WebViewController> _controller;

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
          WebMenuContentViewerBar(_goBackCallback, _goForwardCallback),
          Expanded(
            child: SizedBox(
              height: 1000,
              width: 1000,
              child: StreamBuilder(
                  stream: _bloc.state,
                  initialData: MarkModeState.navigateMode(),
                  builder: (BuildContext context, AsyncSnapshot<MarkModeState>snapshot) {

                    return Stack(
                      children: <Widget>[
                        Visibility(
                          maintainState: true,
                          visible: snapshot.data.isNavigateMode(),
                          child: WebView(
                            initialUrl: _lastUrl,
                            onPageFinished: (String url){_lastUrl = url;},
                            onWebViewCreated: (WebViewController webViewController) {
                              if(_controller.isCompleted == false)
                                _controller.complete(webViewController);
                            },),
                        ),
                        Coverer(snapshot.data.isNavigateMode() == false),
                        Visibility(
                          visible: snapshot.data.isNavigateMode() == false,
                          child: Placeholder(),
                        )



                      ],
                    );
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
    _controller = Completer<WebViewController>();
    _lastUrl = widget._webUrl;
    _bloc = BlocProvider.of<MarkModeBloc>(context);
  }
}

