import 'package:flutter/material.dart';
import 'package:lunch_it/Components/Marker/MarkingManager.dart';

import 'WebMenu/WebMenuContentViewer.dart';

class Menu extends StatelessWidget {
  final WebMenuContentViewer _menuContentViewer;
  final Widget _menuContentViewerNavBar;

  Menu({@required WebMenuContentViewer contentViewer, Widget navbar})
      : _menuContentViewer = contentViewer,
        _menuContentViewerNavBar = navbar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            children: <Widget>[
              if(_menuContentViewerNavBar != null) Flexible(
                child: _menuContentViewerNavBar,
                flex: 1,
              ),
              Flexible(
                flex: 14,
                child: MarkingManager(_menuContentViewer),
              )
            ]
        )
    );
  }
}


