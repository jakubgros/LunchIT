import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
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
        home: Scaffold(
            body: Text("Not implemented")//TODO implement
        )
    );
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
            body: FoodMenusBar(10) //TODO unmock
        )
    );
  }
}

class FoodMenusBar extends StatelessWidget {
  final _amountOfEntries;
  final _menuFractionalRelativeSize = 1/15;

  FoodMenusBar(this._amountOfEntries);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[300],
      child: FractionallySizedBox(
        heightFactor: _menuFractionalRelativeSize,
        child: ListView.separated(
          separatorBuilder: (context, index) => VerticalDivider(
            width: 0,
            color: Colors.black,
          ),
          itemCount: _amountOfEntries,

          scrollDirection: Axis.horizontal,
          itemBuilder: FoodMenusBarEntryBuilder,
        ),
      ),
    );
  }
}

Widget FoodMenusBarEntryBuilder(BuildContext context, int index) //TODO implement
{
  String title = "Menu $index";
  return InkWell(
    onTap: () {;},
    child: FractionallySizedBox(
      heightFactor: 1/2,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(title),
            )
        ),
      ),
    ),
  );

}