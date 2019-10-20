import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBloc.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBlocState.dart';



class WebMenuContentViewer extends StatefulWidget {
  String _webUrl;

  WebMenuContentViewer(this._webUrl);

  @override
  _WebMenuContentViewerState createState() => _WebMenuContentViewerState();
}

class _WebMenuContentViewerState extends State<WebMenuContentViewer> {
  Completer<InAppWebViewController > _controller = Completer<InAppWebViewController >();

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

        return InAppWebView(
          initialUrl: widget._webUrl,
          onWebViewCreated:
              (InAppWebViewController controller) {
            if (_controller.isCompleted == false)
              _controller.complete(controller);
          },
        );
      }
    );
  }
}

