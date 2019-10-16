
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/MenuMarker/MenuMarker.dart';
import 'package:lunch_it/Utilities/utilities.dart';
import 'package:screenshot/screenshot.dart';


class MenuViewer extends StatefulWidget {

  Widget _menuContentViewer;
  Widget _menuContentViewerBar;

  MenuViewer(this._menuContentViewer,
      this._menuContentViewerBar);

  @override
  _MenuViewerState createState() => _MenuViewerState();
}

class _MenuViewerState extends State<MenuViewer> {
  MarkModeBloc _bloc;
  ScreenshotController _screenshotController = ScreenshotController();
  File _menuScreenshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: _bloc.state,
          initialData: MarkModeState.navigateMode(),
          builder:
              (BuildContext context, AsyncSnapshot<MarkModeState> snapshot) {

            if(snapshot.data.isNavigateMode() != true) {
              takeScreenshot();
            }

            return Column(
              children: <Widget>[
                Flexible(
                  child: widget._menuContentViewerBar,
                  flex: 1,
                ),
                Flexible(
                  flex: 14,
                  child: Stack(
                    children: <Widget>[
                      Visibility(
                        child: Screenshot(
                          controller: _screenshotController,
                          child: widget._menuContentViewer,
                        ),
                        visible: true,
                        maintainState: true,),
                      (snapshot.data.isNavigateMode() == false) ? MenuMarker(_menuScreenshot) : null,
                    ].where(notNull).toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
    takeScreenshot();
  }

  void takeScreenshot() {
    _screenshotController.capture().then(
            (File image) async {
          _menuScreenshot = image;
        }
    );
  }
}

