import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as ImgLib;
import 'package:lunch_it/Bloc/AcceptMarkedBloc/AcceptMarkedBloc.dart';
import 'package:lunch_it/Bloc/AcceptMarkedBloc/AcceptMarkedBlocState.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/ContentMarker/MarkedRect.dart';
import 'package:lunch_it/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'package:path_provider/path_provider.dart';

class ContentMarker extends StatefulWidget {
  WebMenuContentViewer _content; //TODO extract abstraction
  MarkModeState _markingMode;
  Future<Uint8List> _screenshotDataBytes;

  ContentMarker({@required content, @required markingMode})
      : _content = content,
        _markingMode = markingMode {
    if (_markingMode.isFoodMode() || _markingMode.isPriceMode())
      _screenshotDataBytes = _content.getScreenshot();
  }

  @override
  _ContentMarkerState createState() => _ContentMarkerState();
}

class _ContentMarkerState extends State<ContentMarker> {
  MarkedRect _markedRect;
  Offset _start = Offset(0, 0);
  Offset _end = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    Color markingColor =
        widget._markingMode.isFoodMode() ? Colors.red[900] : Colors.green[900];

    _markedRect =
        MarkedRect(start: _start, end: _end, borderColor: markingColor);

    bool isMarkingMode = widget._markingMode.isFoodMode() ||
        widget._markingMode.isPriceMode(); //TODO

    return Stack(
      children: <Widget>[
        //TODO Create list that accepts nulls, then it filters it, add method optional(condition, widget)
        widget._content,
        !isMarkingMode
            ? null
            : GestureDetector(
                onPanStart: gesturePanStartCallback,
                onPanUpdate: gesturePanUpdateCallback,
                onPanEnd: gesturePanEndCallback,
                child: Stack(
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: markingColor),
                          ),
                          child: FutureBuilder(
                            future: widget._screenshotDataBytes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Image.memory(snapshot.data);
                              else
                                return Placeholder(); //TODO put sth else here
                            },
                          )),
                    ),
                    _markedRect,
                  ].where(notNull).toList(), //TODO extrat to nullable list
                ),
              ),
      ].where(notNull).toList(),
    );
  }

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

  void gesturePanEndCallback(
      DragEndDetails details) {} //TODO probably safe to remove

  bool shouldTakeScreenshot(MarkModeState markMode) {
    //TODO
    return markMode.isNavigateMode();
  }

  void saveMarked(Uint8List imgAsDataBytes, AcceptMarkedBlocState mode) async {
    MarkModeState markingMode = widget._markingMode;
    bool isMarkingMode = markingMode.isFoodMode() || markingMode.isPriceMode();

    if (isMarkingMode) {
      ImgLib.Image img = ImgLib.decodeImage(imgAsDataBytes);
      ImgLib.Image imgCropped = cropImage(img, _markedRect.rect);
      saveMarkedAsImg(imgCropped, mode);
    }
  }

  ImgLib.Image cropImage(ImgLib.Image img, Rect cropRect) {
    double pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;


    int x = (cropRect.left * pixelRatio).toInt();
    int y = (cropRect.top * pixelRatio).toInt();
    int w = (cropRect.width * pixelRatio).toInt();
    int h = (cropRect.height * pixelRatio).toInt();

    ImgLib.Image imgCropped = ImgLib.copyCrop(img, x, y, w, h);

    return imgCropped;
  }

  void saveMarkedAsImg(ImgLib.Image img, AcceptMarkedBlocState mode) async {
    Directory cacheDir = await getTemporaryDirectory();
    String fileName = (mode.isAcceptMarkedFood() ? "food" : "price") + ".png";

    var saveDir = await Directory("${cacheDir.path}/selected").create();
    File("${saveDir.path}/$fileName").writeAsBytesSync(ImgLib.encodePng(img));
  }

  @override
  void initState() {
    super.initState();

    AcceptMarkedBloc bloc = BlocProvider.of<AcceptMarkedBloc>(context); //TODO

    bloc.state.listen((AcceptMarkedBlocState mode) {      //TODO
      widget._screenshotDataBytes.then((Uint8List bytes) {
        saveMarked(bytes, mode);
      });
    });
  }

  void resetMarker() {
    _start = Offset(0, 0);
    _end = Offset(0, 0);
  }

  @override
  void didUpdateWidget(ContentMarker oldWidget) {
    if (oldWidget._markingMode != widget._markingMode)
      setState(() {
        resetMarker();
      });
  }
}

//TODO fix bug with not working hot reload
