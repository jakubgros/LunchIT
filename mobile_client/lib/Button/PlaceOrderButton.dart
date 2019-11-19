import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/BasketModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/Routes.dart';
import 'package:lunch_it/Utilities/Utils.dart';
import 'package:provider/provider.dart';

class PlaceOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton.icon(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.all(0.0),
            icon: Icon(Icons.check),
            label: Text("Place order!"),
            color: Colors.green[300],
            onPressed: () => _placeOrder(context),
          ),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context) async {
    final basketData = Provider.of<Basket>(context, listen: false);

    int orderRequestId = Provider.of<OrderRequest>(context).orderRequestId;
    var order = OrderResponse(basketData, orderRequestId);
    Future<bool> success = ServerApi().placeOrder(order);


    if(await success == false) {
      displayInfoDialog(
          context: context,
          title: "Order failed!",
          message: "Uncrecognized error",
          onPressOkCallback: () => Navigator.of(context).pop(),
      );
    }
    else {
      displayInfoDialog(
          context: context,
          title: "Success!",
          message: "Your order has been successfuly placed!",
          onPressOkCallback: () {
            basketData.clear();
            Navigator.of(context).pushNamed(Routes.home);
          }
      );
    }
  }
}
