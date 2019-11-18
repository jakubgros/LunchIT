import 'package:flutter/material.dart';
import 'package:lunch_it/Basket/Model/Basket.dart';
import 'package:lunch_it/Basket/Model/OrderResponse.dart';
import 'package:lunch_it/Models/OrderRequestModel.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';
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
    if(await success == false)
      return; //TODO display message that request to server failed

    basketData.clear();

    Navigator.of(context).pushNamed('/succesfulOrder');
  }
}
