import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'dart:core';

import 'package:screenshot/screenshot.dart';


class MenuMarker extends StatefulWidget {

  AssetImage _screenshot;
  MenuMarker(File screenshot)
  {
    _screenshot =  AssetImage(screenshot.path);
  }

  @override
  _MenuMarkerState createState() => _MenuMarkerState();
}

class _MenuMarkerState extends State<MenuMarker> {
  Offset _start;
  Offset _end;

  File _foodScreenshot;
  ScreenshotController _screenshotController;

  void gesturePanStartCallback(DragStartDetails details) {
    setState((){
      _start = details.localPosition;
    });
  }

  void gesturePanUpdateCallback(DragUpdateDetails details) {
    setState(() {
      _end = details.localPosition;
    });
  }

  void gesturePanEndCallback(DragEndDetails details) {
    //takeScreenshot();
  }

  void takeScreenshot() {
    _screenshotController.capture().then(
            (File image) async {
          _foodScreenshot = image;
        }
    );
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
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
              child: Image(
                  image: widget._screenshot
              ),
            ),
          ),
          _start != null && _end != null ? Marker(_start, _end) : null,
        ].where(notNull).toList(),
      ),
    );
  }
}


class Marker extends StatelessWidget {
  Rect _rect;

  Marker(Offset start, Offset end) {
    _rect = Rect.fromPoints(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _rect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green[900]),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
          ),
        ),
      ),
    );
  }
}