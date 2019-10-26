import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as ImgLib;

import 'MarkedRect.dart';

class ContentMarker extends StatefulWidget {
  Color _markingColor;
  Future<Uint8List> Function() _getScreenshotCallback;
  MarkedRect _markedRect;

  ContentMarker({
    @required Color markingColor,
    @required Future<Uint8List> Function() getScreenshotCallback,
  })  : _markingColor = markingColor,
        _getScreenshotCallback = getScreenshotCallback;

  @override
  _ContentMarkerState createState() => _ContentMarkerState();

  Future<ImgLib.Image> getMarked() async {
    Uint8List screenshot = await _getScreenshotCallback();
    ImgLib.Image img = ImgLib.decodeImage(screenshot);

    Rect markedRect = _markedRect.rect;
    ImgLib.Image imgCropped = cropImage(img, markedRect);
    return imgCropped;
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
}

class _ContentMarkerState extends State<ContentMarker> {
  Offset _start = Offset(0, 0);
  Offset _end = Offset(0, 0);

  var screenshot;

  @override
  void initState() {
    screenshot = widget._getScreenshotCallback();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: gesturePanStartCallback,
      onPanUpdate: gesturePanUpdateCallback,
      onPanEnd: gesturePanEndCallback,
      child: LayoutBuilder(
          builder: (context, constraints) => Stack(children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                      decoration: BoxDecoration( //TODO do sth about it
                        border: Border.all(color: widget._markingColor),
                      ),
                      child: FutureBuilder(
                        future: screenshot,
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Image.memory(snapshot.data);
                          else
                            return Placeholder(); //TODO put sth else here
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

  //TODO probably safe to remove
  void gesturePanEndCallback(DragEndDetails details) {}
}
