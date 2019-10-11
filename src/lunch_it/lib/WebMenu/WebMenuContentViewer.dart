import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                        Visibility( // to prevent clicks on the widget underneath
                          visible: snapshot.data.isNavigateMode() == false,
                          child: SizedBox(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Spacer()
                                ],
                              ),
                              color: Colors.red[500],
                            ),
                            height: 1000,
                            width: 1000,
                          ),
                        ),


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
