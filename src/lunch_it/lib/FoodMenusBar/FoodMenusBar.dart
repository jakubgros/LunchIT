import 'package:flutter/material.dart';
import 'package:lunch_it/FoodMenusBar/FoodMenusBarEntryBuilder.dart';

class FoodMenusBar extends StatelessWidget { //TODO make elements extended if listview is not scrollable
  final _amountOfEntries;

  FoodMenusBar(this._amountOfEntries);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
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
    );
  }
}



