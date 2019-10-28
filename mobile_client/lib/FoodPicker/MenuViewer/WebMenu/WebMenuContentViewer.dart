import 'dart:async';
import 'dart:io';
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
  Completer<InAppWebViewController> _controller = Completer<InAppWebViewController>();

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrl: widget._webUrl,
      onWebViewCreated: (controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget._controller = _controller;
  }


  @override
  void didUpdateWidget(WebMenuContentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._controller = _controller;
  }

  @override
  void didChangeDependencies() {
    Provider.of<WebNavigationEventStream>(context).stream.listen((WebNavigationEvent event){
      if (event.isGoBack())
        _controller.future.then((controller) => controller.goBack());
      if (event.isGoForward())
        _controller.future.then((controller) => controller.goForward());
    });
  }


}