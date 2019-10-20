import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/MenuMarker/MarkedRect.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'dart:core';

class MenuMarker extends StatefulWidget {

  //AssetImage _screenshot;
  MenuMarker(File screenshot)
  {
    //_screenshot =  AssetImage(screenshot.path);
  }

  @override
  _MenuMarkerState createState() => _MenuMarkerState();
}

class _MenuMarkerState extends State<MenuMarker> {
  Offset _start;
  Offset _end;

  File _foodScreenshot;

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
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {}, //without this,taps are interpreted as pans
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
              child: Placeholder(), //TODO put image here
            ),
          ),
          _start != null && _end != null ? MarkedRect(_start, _end) : null,
        ].where(notNull).toList(),
      ),
    );
  }
}
