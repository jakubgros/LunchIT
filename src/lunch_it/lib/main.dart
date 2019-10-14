import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';

import 'Bloc/NavbarBloc/NavbarBloc.dart';
import 'BottomBar/BottomBar.dart';
import 'FoodMenusBar/FoodMenusBar.dart';

import 'Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'MenuViewer/MenuViewer.dart';
import 'MenuViewer/WebMenu/WebMenuContentViewer.dart';
import 'MenuViewer/WebMenu/WebMenuContentViewerBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? VerticalLayout()
          : HorizontalLayout();
    });
  }
}

class HorizontalLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: Text("Not implemented") //TODO implement
            ));
  }
}

class VerticalLayout extends StatelessWidget {
  MarkModeBloc _markModeBloc;

  final VoidCallback _shoppingCartOnPressedCallback = () {}; //TODO implement
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                InkWell(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: _shoppingCartOnPressedCallback,
                  ),
                )
              ],
              title: Text("#MAIL TITLE#"), //TODO dehardcode
              leading: BackButton(),

            ),
            body: BlocProvider<MarkModeBloc>( //TODO exclude BottomMenuBar from this bloc
              bloc: MarkModeBloc(),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FoodMenusBar(2), //TODO dehardcode
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 18,
                    child: Row(
                      children: <Widget>[
                        BlocProvider<NavbarBloc>(
                            bloc: NavbarBloc(),
                            child: MenuViewer(
                                WebMenuContentViewer('https://www.uszwagra24.pl/menu/'),
                                WebMenuViewersBar()
                                )),
                      ],
                    )
                  ),
                  Expanded(
                    flex:2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        BottomMenuBar(),
                      ],
                    ),
                  ),
                ],
              ),
            )
            ));
  }
}
