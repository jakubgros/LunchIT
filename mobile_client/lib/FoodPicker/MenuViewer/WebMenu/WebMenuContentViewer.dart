import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:lunch_it/FoodPicker/EventStreams/WebNavigation.dart';
import 'package:provider/provider.dart';


class WebMenuContentViewer extends StatefulWidget {
  final String _webUrl;
  Completer<InAppWebViewController> _controller;

  WebMenuContentViewer({@required String url}) : _webUrl = url;

  Future<Uint8List> getScreenshot() async {
    var controller = await _controller.future;
    var imgAsDataBytes = await controller.takeScreenshot();
    return imgAsDataBytes;
  }

  @override
  _WebMenuContentViewerState createState() => _WebMenuContentViewerState();
}

class _WebMenuContentViewerState extends State<WebMenuContentViewer> {
  final _controller = Completer<InAppWebViewController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder( //TODO replace stream builder with listener
        stream: Provider.of<WebNavigationEventStream>(context).stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isGoBack())
              _controller.future.then((controller) => controller.goBack());
            if (snapshot.data.isGoForward())
              _controller.future.then((controller) => controller.goForward());
          }

          return InAppWebView(
            initialUrl: widget._webUrl,
            onWebViewCreated: (controller) {
              _controller.complete(controller);
            },
          );
        });
  }



  @override
  void initState() {
    super.initState();
    widget._controller=_controller;
  }

  @override
  void didUpdateWidget(WebMenuContentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._controller=_controller;
  }


}
