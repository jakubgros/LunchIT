import 'package:flutter/material.dart';

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
              title: Text("#MAIL TITLE#"), //TODO
              leading: BackButton(),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FoodMenusBar(2),
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
                      BottomMenu(),
                    ],
                  ),
                ),
              ],
            ) //TODO unmock
            ));
  }
}

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Food"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Food"),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Food"),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Suma: 100zl",
                        textAlign: TextAlign.start,),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Pozostalo: 20zl",
                          textAlign: TextAlign.end,),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

}
