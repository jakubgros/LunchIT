import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/FoodMenusBar/BarEntryBuilder.dart';

class FoodMenusBar extends StatelessWidget {
  //TODO make elements extended if listview is not scrollable
  final int _amountOfEntries;
  final Color _listColor;
  final Color _separatorColor;

  FoodMenusBar({
    @required int amountOfEntries,
    @required Color listColor,
    @required Color separatorColor,
  })  : _amountOfEntries = amountOfEntries,
        _listColor = listColor,
        _separatorColor = separatorColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _listColor,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => VerticalDivider(
          width: 0,
          color: _separatorColor,
        ),
        itemCount: _amountOfEntries,
        scrollDirection: Axis.horizontal,
        itemBuilder: BarEntryBuilder,
      ),
    );
  }
}
