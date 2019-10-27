import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as ImgLib;
import 'package:lunch_it/FoodPicker/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/FoodPicker/EventStreams/MarkerMode.dart';
import 'package:lunch_it/FoodPicker/Marker/ContentMarker.dart';
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
  Future<Directory> _saveDir;

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
              getScreenshotCallback: (){print("xDDDD"); return widget._content.getScreenshot();},
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
    createSaveDirectory();
  }

  void createSaveDirectory() async {
    var cacheDir = await getTemporaryDirectory();
    _saveDir = Directory("${cacheDir.path}/selected").create();
  }

  void saveMarked(Future<ImgLib.Image> markedAsImage, AcceptMarkedEvent markingMode) async {
      String fileName = (markingMode.isAcceptMarkedFood() ? "food" : "price") + ".png";
      var saveDir = await _saveDir;
      File("${saveDir.path}/$fileName").writeAsBytesSync(ImgLib.encodePng(await markedAsImage));
  }

  bool _isAcceptMarkedEventStreamListened = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(_isAcceptMarkedEventStreamListened == false) {
      _isAcceptMarkedEventStreamListened = true;

      Provider
          .of<AcceptMarkedEventStream>(context)
          .stream
          .listen(
              (AcceptMarkedEvent event) {
            if(_contentMarker != null){
              Future<ImgLib.Image> markedImg = _contentMarker.getMarked();
              saveMarked(markedImg, event);
            }


          }
      );
    }
    }
}