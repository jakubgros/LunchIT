import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as ImgLib;

import 'MarkedRect.dart';
import 'dart:ui' as ui;

Future<ImgLib.Image> createImageOutOfMarkedRectAndBackground(Map args) async {
  assert(args.containsKey('background'));
  assert(args.containsKey('markedRect'));
  assert(args.containsKey('pixelRatio'));
  Rect markedRect = args['markedRect'];
  Uint8List backgroundImgAsBytes = args['background'];
  double pixelRatio = args['pixelRatio'];

  ImgLib.Image img = ImgLib.decodeImage(backgroundImgAsBytes);
  ImgLib.Image imgCropped = cropImage(img, markedRect, pixelRatio);
  return imgCropped;
}

ImgLib.Image cropImage(ImgLib.Image img, Rect cropRect, double pixelRatio) {
  int x = (cropRect.left * pixelRatio).toInt();
  int y = (cropRect.top * pixelRatio).toInt();
  int w = (cropRect.width * pixelRatio).toInt();
  int h = (cropRect.height * pixelRatio).toInt();

  ImgLib.Image imgCropped = ImgLib.copyCrop(img, x, y, w, h);

  return imgCropped;
}

class ContentMarker extends StatefulWidget {
  final Color _markingColor;
  final Future<Uint8List> Function() _getScreenshotCallback;
  MarkedRect _markedRect;
  Uint8List _screenshotAsBytes;

  ContentMarker({
    @required Color markingColor,
    @required Future<Uint8List> Function() getScreenshotCallback,
  })  : _markingColor = markingColor,
        _getScreenshotCallback = getScreenshotCallback;

  @override
  _ContentMarkerState createState() => _ContentMarkerState();

  Future<ImgLib.Image> getMarked() async {

    var args = {
      'background': _screenshotAsBytes,
      'markedRect': _markedRect.rect,
      'pixelRatio': WidgetsBinding.instance.window.devicePixelRatio
    };

    ImgLib.Image markedAsImg = await compute(createImageOutOfMarkedRectAndBackground, args);
    return markedAsImg;
  }
}

class _ContentMarkerState extends State<ContentMarker> {
  Offset _start = Offset(0, 0);
  Offset _end = Offset(0, 0);

  Future<Uint8List> _screenshot;

  @override
  void initState() {
    super.initState();
    _screenshot = widget._getScreenshotCallback();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: gesturePanStartCallback,
      onPanUpdate: gesturePanUpdateCallback,
      child: LayoutBuilder(
          builder: (context, constraints) => Stack(children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                      decoration: BoxDecoration( //TODO do sth about it
                        border: Border.all(color: widget._markingColor),
                      ),
                      child: FutureBuilder(
                        future: _screenshot,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            widget._screenshotAsBytes = snapshot.data;
                            return Image.memory(snapshot.data);
                          }
                          else {
                            return BackdropFilter(
                                filter:  ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  child: new Container(
                                    decoration: new BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                  ),
                                ),
                              );
                          }
                        },
                      )),
                ),
                widget._markedRect = MarkedRect(
                    start: _start,
                    end: _end,
                    constraints: constraints,
                    borderColor: widget._markingColor),
              ])),
    );
  }

  void gesturePanStartCallback(DragStartDetails details) =>
    setState(() {_start = details.localPosition;});

  void gesturePanUpdateCallback(DragUpdateDetails details) =>
    setState(() {_end = details.localPosition;});
}
