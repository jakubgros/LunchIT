
import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';

import 'Coverer.dart';

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
  GlobalKey _screenAreaKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: StreamBuilder(
          stream: _bloc.state,
          initialData: MarkModeState.navigateMode(),
          builder:
              (BuildContext context, AsyncSnapshot<MarkModeState> snapshot) {
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
                        child: RepaintBoundary(
                            child: widget._menuContentViewer,
                            key: _screenAreaKey
                        ),
                        visible: true,
                        maintainState: true,),
                      Coverer(snapshot.data.isNavigateMode() == false),
                      Visibility(
                        visible: snapshot.data.isNavigateMode() == false,
                        child: Placeholder(),
                      )
                    ],
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
