import 'package:flutter/material.dart';

import 'BottomMenuBar.dart';
import 'FoodMenusBar.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("#MAIL TITLE#"), //TODO dehardcode
              leading: BackButton(),
            ),
            body: Column(
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
                  flex: 8,
                  child: Placeholder() //TODO menu content
                ),
                Expanded(
                  flex:1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      BottomMenuBar(),
                    ],
                  ),
                ),
              ],
            )
            ));
  }
}
