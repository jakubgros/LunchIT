import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/Presenters/MealCard.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';

class OrderResponsePage extends StatelessWidget {
  final OrderRequestModel orderRequest;
  Future<List<MealModel>> _orderEntries;

  OrderResponsePage(this.orderRequest) {
    _orderEntries = ServerApi().getPlacedOrder(orderRequest.placedOrderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MealModel>>(
        initialData: List<MealModel>(),
        future: _orderEntries,
        builder: (context, snapshot) {
          double totalCost = snapshot.data
              .fold(0, (prev, MealModel elem) => prev + elem.price*elem.quantity);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  "${orderRequest.title}"),
            ),
            body: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  MealCard.presenter(snapshot.data[index]),
            ),
            bottomSheet: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      color: Colors.blue[400],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Total cost: ${totalCost.toStringAsFixed(2)} PLN",
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
        });
  }
}
