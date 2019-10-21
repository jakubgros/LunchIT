import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/MenuMarker/Marker.dart';
import 'package:lunch_it/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:lunch_it/Utilities/utilities.dart';


class Menu extends StatefulWidget {

  WebMenuContentViewer _menuContentViewer; //TODO extract to abstract
  Widget _menuContentViewerBar;

  Menu(this._menuContentViewer, this._menuContentViewerBar);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  MarkModeBloc _bloc;

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
                    child: Marker(widget._menuContentViewer, snapshot.data),
                  )
                ],
              );
            }
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
  }

}
