import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/Marker/MarkingManager.dart';
import 'package:lunch_it/FoodPicker/MenuViewer/WebMenu/WebMenuContentViewer.dart';

class Menu extends StatefulWidget {
  final WebMenuContentViewer _menuContentViewer; //TODO extract to abstract
  final Widget _menuContentViewerNavBar; //TODO extract to abstract

  Menu({@required WebMenuContentViewer contentViewer, Widget navbar})
      : _menuContentViewer = contentViewer,
        _menuContentViewerNavBar = navbar;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {   //TODO probably can change to stateless

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: <Widget>[
            if(widget._menuContentViewerNavBar != null) Flexible(
              child: widget._menuContentViewerNavBar,
              flex: 1,
            ),
            Flexible(
              flex: 14,
              child: MarkingManager(widget._menuContentViewer, key: UniqueKey()),
            )
          ]
        )
    );
  }
}