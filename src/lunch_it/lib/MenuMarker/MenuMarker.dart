import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  double _startX = 0;
  double _startY = 0;
  double _endX = 0;
  double _endY = 0;

  Offset _start;
  Offset _end;

  File _foodScreenshot;
  ScreenshotController _screenshotController;

  void gesturePanStartCallback(DragStartDetails details) {
    var localPos = details.localPosition;


    setState((){
      _start = details.localPosition;

      _startX = localPos.dx;
      _startY = localPos.dy;
    });
  }

  void gesturePanUpdateCallback(DragUpdateDetails details) {
    var localPos = details.localPosition;

    setState(() {
      _end = details.localPosition;

      _endX = localPos.dx;
      _endY = localPos.dy;
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
          if(_start != null && _end != null) Marker(_start, _end),
        ],
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



/*
class Marker extends StatelessWidget {
  AxisDirection _horizontalDir;
  AxisDirection _verticalDir;
  double _width;
  double _height;
  double _x;
  double _y;
  Container _container;

  Marker(this._horizontalDir, this._verticalDir, this._width, this._height,
      this._x, this._y, Color color) {
    _container = Container(
      decoration: BoxDecoration(
        border: Border.all(color: color),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_horizontalDir == AxisDirection.up && _verticalDir == AxisDirection.left){

    } else if(_horizontalDir == AxisDirection.up && _verticalDir == AxisDirection.right){

    } else if(_horizontalDir == AxisDirection.down && _verticalDir == AxisDirection.left){

    } else if(_horizontalDir == AxisDirection.down && _verticalDir == AxisDirection.right){

    }


  }
}
*/

