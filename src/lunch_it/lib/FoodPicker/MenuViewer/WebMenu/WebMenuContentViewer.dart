import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:lunch_it/FoodPicker/Bloc/BlocProvider.dart';
import 'package:lunch_it/FoodPicker/Bloc/NavbarBloc/NavbarBloc.dart';
import 'package:lunch_it/FoodPicker/Bloc/NavbarBloc/NavbarBlocState.dart';

class WebMenuContentViewer extends StatelessWidget {
  final String _webUrl;
  final _controller = Completer<InAppWebViewController>();

  WebMenuContentViewer({@required String url}) : _webUrl = url;

  @override
  Widget build(BuildContext context) {
    NavbarBloc _bloc = BlocProvider.of<NavbarBloc>(context);
    return StreamBuilder<NavbarBlocState>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isGoBack()) //TODO
              _controller.future.then((controller) => controller.goBack());
            if (snapshot.data.isGoForward())
              _controller.future.then((controller) => controller.goForward());
          }

          return InAppWebView(
            initialUrl: _webUrl,
            onWebViewCreated: (controller) {
              _controller.complete(controller);
            },
          );
        });
  }

  Future<Uint8List> getScreenshot() async {
    var controller = await _controller.future;
    var imgAsDataBytes = await controller.takeScreenshot();
    return imgAsDataBytes;
  }
}
