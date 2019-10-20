import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/MenuMarker/MarkedRect.dart';
import 'package:lunch_it/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'dart:core';

class Marker extends StatefulWidget {

  WebMenuContentViewer _menuContentViewer; //TODO extract abstraction
  bool _isMarkingMode;
  Future<Image> _screenshot;

  Marker(this._menuContentViewer, this._isMarkingMode) {
    if(_isMarkingMode)
      _screenshot = _menuContentViewer.getScreenshot();
  }

  @override
  _MarkerState createState() => _MarkerState();


}

class _MarkerState extends State<Marker> {
  Offset _start;
  Offset _end;

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
    return Stack(
        children: <Widget>[
        widget._menuContentViewer,
          widget._isMarkingMode == false ? null : GestureDetector(
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
                  child: FutureBuilder(
                    future: widget._screenshot,
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                        return snapshot.data;
                      else
                        return Placeholder(); //TODO put sth else here
                    },
                  )
                ),
              ),
              _start != null && _end != null ? MarkedRect(_start, _end) : null,
            ].where(notNull).toList(),
          ),
        ),
      ].where(notNull).toList(),
    );
  }
}
