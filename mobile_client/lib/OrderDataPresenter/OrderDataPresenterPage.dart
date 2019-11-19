import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Basket/Model/Meal.dart';
import 'package:lunch_it/Basket/View/BasketEntryCard.dart';
import 'package:lunch_it/OrderRequest/OrderRequestModel.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class OrderDataPresenterPage extends StatelessWidget {
  final OrderRequest orderRequest;
  Future<List<Meal>> _orderEntries;

  OrderDataPresenterPage(this.orderRequest) {
    _orderEntries = ServerApi().getPlacedOrder(orderRequest.placedOrderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>>(
        initialData: List<Meal>(),
        future: _orderEntries,
        builder: (context, snapshot) {
          double totalCost = snapshot.data
              .fold(0, (prev, Meal elem) => prev + elem.price);
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
