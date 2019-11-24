import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/PlacedOrderBloc.dart';
import 'package:lunch_it/DataModels/PlacedOrderModel.dart';
import 'package:lunch_it/Presenters/MealCard.dart';
import 'package:provider/provider.dart';

class PlacedOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlacedOrderModel>(
        stream: Provider.of<PlacedOrderBloc>(context).placedOrder,
        builder: (context, snapshot) {
          if(snapshot.hasData == false)
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          else {
            var placedOrder = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(placedOrder.connectedOrderRequest.title),
              ),
              body: ListView.builder(
                itemCount: placedOrder.orderedMeals.length,
                itemBuilder: (context, index) =>
                    MealCard.presenter(placedOrder.orderedMeals[index]),
              ),
              bottomSheet: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        color: Colors.blue[400],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total cost: ${placedOrder.totalCost.toStringAsFixed(2)} PLN",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            );
          }

        });
  }
}
