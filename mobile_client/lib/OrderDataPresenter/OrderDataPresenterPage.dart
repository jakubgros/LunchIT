import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Basket/BasketEntry.dart';
import 'package:lunch_it/Basket/BasketEntryCard.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class OrderDataPresenterPage extends StatelessWidget {
  final OrderRequest orderRequest;

  OrderDataPresenterPage(this.orderRequest);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("[${orderRequest.deadlineAsFormattedStr}] ${orderRequest.title}"),
        ),
        body: FutureBuilder<List<BasketEntry>>(
            initialData: List<BasketEntry>(),
            future: ServerApi().getPlacedOrder(orderRequest.placedOrderId),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    BasketEntryCard.presenter(snapshot.data[index]),
              );
            }
        ));
  }

}
