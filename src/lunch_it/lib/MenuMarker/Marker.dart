import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/MenuMarker/MarkedRect.dart';
import 'package:lunch_it/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'dart:core';
import 'package:image/image.dart' as ImgLib;
import 'package:path_provider/path_provider.dart';

class Marker extends StatefulWidget {

  WebMenuContentViewer _menuContentViewer; //TODO extract abstraction
  bool _isMarkingMode;
  Future<Uint8List> _screenshotDataBytes;

  Marker(this._menuContentViewer, this._isMarkingMode) {
    if(_isMarkingMode)
      _screenshotDataBytes = _menuContentViewer.getScreenshot();
  }

  @override
  _MarkerState createState() => _MarkerState();


}

class _MarkerState extends State<Marker> {

  MarkedRect _markedRect;
  Image _savedMarked;

  Offset _start = Offset(0, 0);
  Offset _end = Offset(0, 0);

  void gesturePanStartCallback(DragStartDetails details) {
    setState(() {
      _start = details.localPosition;
    });
  }

  void gesturePanUpdateCallback(DragUpdateDetails details) {
    setState(() {
      _end = details.localPosition;
    });
  }

  void gesturePanEndCallback(DragEndDetails details) {
  }

  @override
  Widget build(BuildContext context) {
    _markedRect = MarkedRect(_start, _end);

    return Stack(
      children: <Widget>[
        widget._menuContentViewer,
        widget._isMarkingMode == false ? null : GestureDetector(
          onPanStart: gesturePanStartCallback,
          onPanUpdate: gesturePanUpdateCallback,
          onPanEnd: gesturePanEndCallback,
          child: Stack(
            children: <Widget>[
              FittedBox(
                fit: BoxFit.cover,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[900]),
                    ),
                    child: FutureBuilder(
                      future: widget._screenshotDataBytes,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Image.memory(snapshot.data);
                        else
                          return Placeholder(); //TODO put sth else here
                      },
                    )
                ),
              ),
              _markedRect,
            ].where(notNull).toList(),
          ),
        ),
      ].where(notNull).toList(),
    );
  }

  bool shouldTakeScreenshot(MarkModeState markMode) {
    return markMode.isNavigateMode();
  }

  void saveMarkedImage(Uint8List imgAsDataBytes) async {
    if (widget._isMarkingMode) {
      Rect rect = _markedRect.rect;

      double pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

      ImgLib.Image img = ImgLib.decodeImage(imgAsDataBytes);

      int x = (rect.left * pixelRatio).toInt();
      int y = (rect.top * pixelRatio).toInt();
      int w = (rect.width * pixelRatio).toInt();
      int h = (rect.height * pixelRatio).toInt();

      ImgLib.Image imgCropped = ImgLib.copyCrop(img, x, y, w, h);

      var cacheDir = await getTemporaryDirectory();
      String fileName = DateTime.now().toIso8601String();
      var scrDir = Directory("${cacheDir.path}/scr_$fileName.png");

      new File(scrDir.path).writeAsBytesSync(ImgLib.encodePng(imgCropped));
      print("[IMG} ${scrDir.path} saved");
    }
  }

  @override
  void initState() {
    super.initState();

    MarkModeBloc bloc = BlocProvider.of<MarkModeBloc>(context);

    bloc.state
        .where(shouldTakeScreenshot)
        .listen((MarkModeState) {
      widget._screenshotDataBytes.then(saveMarkedImage);
    });
  }
}