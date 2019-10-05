import 'package:flutter/material.dart';

class FoodMenusBar extends StatelessWidget { //TODO make elements extended if listview is not scrollable
  final _amountOfEntries;
  final _menuFractionalRelativeSize = 1/15;

  FoodMenusBar(this._amountOfEntries);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
      child: FractionallySizedBox(
        heightFactor: _menuFractionalRelativeSize,
        child: ListView.separated(
          shrinkWrap: true,
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

class FoodMenusBarEntry extends StatelessWidget
{
  final VoidCallback _onTapCallback;
  final String _title;

  FoodMenusBarEntry(this._title, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _onTapCallback,
        child: FractionallySizedBox(
          heightFactor: 1 / 2,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(_title),
                )
            ),
          ),
        ),
      ),
    );
  }
}

Widget FoodMenusBarEntryBuilder(BuildContext context, int index) //TODO implement
{
  String title = "Menu $index";
  VoidCallback mockedEmptyCallback = () {};
  return new FoodMenusBarEntry(title, mockedEmptyCallback);
}
