import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/Bloc/BlocProvider.dart';
import 'package:lunch_it/FoodPicker/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/FoodPicker/Bloc/MarkModeBloc/MarkModeState.dart';
import 'package:lunch_it/FoodPicker/ContentMarker/ContentMarker.dart';
import 'package:lunch_it/FoodPicker/MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'package:lunch_it/Utilities/utilities.dart';

class Menu extends StatefulWidget {
  final WebMenuContentViewer _menuContentViewer; //TODO extract to abstract
  final Widget _menuContentViewerNavBar; //TODO extract to abstract

  Menu({@required WebMenuContentViewer contentViewer, Widget navbar})
      : _menuContentViewer = contentViewer,
        _menuContentViewerNavBar = navbar;

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
                  widget._menuContentViewerNavBar == null
                      ? null
                      : Flexible(
                          child: widget._menuContentViewerNavBar,
                          flex: 1,
                        ),
                  Flexible(
                    flex: 14,
                    child: ContentMarker(
                        content: widget._menuContentViewer,
                        markingMode: snapshot.data),
                  )
                ].where(notNull).toList(), //TODO
              );
            }));
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context); //TODO
  }
}
