import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:image/image.dart' as ImgLib;
import 'package:lunch_it/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/EventStreams/MarkerMode.dart';
import 'package:lunch_it/FoodPicker/Marker/ContentMarker.dart';
import 'package:lunch_it/FoodPicker/Marker/MarkerData.dart';
import 'package:lunch_it/FoodPicker/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MarkingManager extends StatefulWidget {
  final WebMenuContentViewer _content; //TODO extract abstraction

  MarkingManager(this._content);

  @override
  _MarkingManagerState createState() => _MarkingManagerState();
}

class _MarkingManagerState extends State<MarkingManager> {
  List<Widget> _stackContent;
  ContentMarker _contentMarker;
  final _contentMarkerStateKey = GlobalKey<ContentMarkerState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: MarkerModeEvent.navigate(),
        stream: Provider
            .of<MarkerModeEventStream>(context)
            .stream,
        builder: (context, snapshot) {
          Color markingColor = snapshot.data.isMarkFood()
              ? Colors.red[900]
              : Colors.green[900];

          bool isMarkingMode = !snapshot.data.isNavigate();

          _stackContent.removeWhere((Widget widget)=> widget is ContentMarker);

          if (!isMarkingMode)
            _contentMarker = null;
          else {
            _contentMarker = ContentMarker(
              key: _contentMarkerStateKey,
              getScreenshotCallback: widget._content.getScreenshot,
              markingColor: markingColor,);
            _stackContent.add(_contentMarker);
          }
          
          return Stack(children: _stackContent);
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _stackContent = [widget._content];

    Provider.of<AcceptMarkedEventStream>(context, listen: false).stream.listen((AcceptMarkedEvent event) {
      assert(_contentMarker != null);
      if(!_contentMarkerStateKey.currentState.hasMarked)
        return;

      Future<ImgLib.Image> markedImg = _contentMarker.getMarked();
      saveMarked(markedImg, event);
    }
    );
  }

  void saveMarked(Future<ImgLib.Image> markedAsImage, AcceptMarkedEvent markingMode) async {
      Directory cacheDir = await getTemporaryDirectory();
      String fileName = uuidGenerator.v1() + ".png";
      File file = File("${cacheDir.path}/$fileName");
      file.writeAsBytesSync(ImgLib.encodePng(await markedAsImage));

      MarkerData markerData = Provider.of<MarkerData>(context, listen: false);

    if(markingMode.isAcceptMarkedFood())
      markerData.addFood(file);
    else
      markerData.addPrice(file);
  }
}