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
