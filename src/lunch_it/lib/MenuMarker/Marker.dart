import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/AcceptMarkedBloc/AcceptMarkedBloc.dart';
import 'package:lunch_it/Bloc/AcceptMarkedBloc/AcceptMarkedBlocState.dart';
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
  MarkModeState _markingMode;
  Future<Uint8List> _screenshotDataBytes;

  Marker(this._menuContentViewer, this._markingMode) {
    if(_markingMode.isFoodMode() || _markingMode.isPriceMode())
      _screenshotDataBytes = _menuContentViewer.getScreenshot();
  }

  @override
  _MarkerState createState() => _MarkerState();


}

class _MarkerState extends State<Marker> {
  MarkedRect _markedRect;
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

    Color markingColor = widget._markingMode.isFoodMode() ? Colors.red[900] : Colors.green[900];

    _markedRect = MarkedRect(_start, _end, markingColor);

    bool isMarkingMode = widget._markingMode.isFoodMode() || widget._markingMode.isPriceMode();

    return Stack(
      children: <Widget>[
        widget._menuContentViewer,
        !isMarkingMode ? null : GestureDetector(
          onPanStart: gesturePanStartCallback,
          onPanUpdate: gesturePanUpdateCallback,
          onPanEnd: gesturePanEndCallback,
          child: Stack(
            children: <Widget>[
              FittedBox(
                fit: BoxFit.cover,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: markingColor
                      ),
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

  void saveMarkedImage(Uint8List imgAsDataBytes, AcceptMarkedBlocState mode) async {
    bool isMarkingMode = widget._markingMode.isFoodMode() || widget._markingMode.isPriceMode();

    if (isMarkingMode) {
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

      String modePrefix = mode.isAcceptMarkedFood() ? "food" : "price";

      var scrDir = Directory("${cacheDir.path}/scr_{$modePrefix}_{$fileName}.png");

      new File(scrDir.path).writeAsBytesSync(ImgLib.encodePng(imgCropped));
      print("[IMG] ${scrDir.path} saved");
    }
  }

  @override
  void initState() {
    super.initState();

    AcceptMarkedBloc bloc = BlocProvider.of<AcceptMarkedBloc>(context);

    bloc.state.listen((AcceptMarkedBlocState mode) {
      widget._screenshotDataBytes.then((Uint8List bytes){saveMarkedImage(bytes, mode);});
    });
  }

  @override
  void didUpdateWidget(Marker oldWidget) {
    if(oldWidget._markingMode != widget._markingMode)
      setState(() {
        _start = Offset(0, 0);
        _end = Offset(0, 0);
      });
  }
}