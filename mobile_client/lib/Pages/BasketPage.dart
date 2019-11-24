import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/OrderBloc.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/Presenters/MealCard.dart';
import 'package:lunch_it/Button/PlaceOrderButton.dart';
import 'package:lunch_it/Bar/CashInfoBar.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Consumer<OrderResponseBloc>(builder: (context, basketBloc, child) {
      return StreamBuilder<List<MealModel>> (
        initialData: <MealModel>[],
        stream: basketBloc.basket,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(),
              body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    MealCard.modifiable(snapshot.data[index], index, basketBloc)
              ),
              bottomSheet: FractionallySizedBox(
                heightFactor: 1/10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PlaceOrderButton(),
                    Expanded(child: CashInfoBar()),
                  ],
                ),
              ));
        }
      );

    });
}

