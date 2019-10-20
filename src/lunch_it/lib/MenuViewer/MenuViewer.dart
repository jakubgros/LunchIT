import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/MenuMarker/MenuMarker.dart';
import 'package:lunch_it/Utilities/utilities.dart';


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
  File _menuScreenshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: _bloc.state,
          initialData: MarkModeState.navigateMode(),
          builder: (context, snapshot) {
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
                        child: widget._menuContentViewer,
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
  }
}

