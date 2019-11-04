import 'package:flutter/material.dart';
import 'package:lunch_it/Basket/BasketData.dart';
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
    final basketData = Provider.of<BasketData>(context, listen: false);

    //TODO
/*    final orderInfo = Provider.of<OrderInfo>(context, listen: false);
    if(basketData.getSummaryCost() > orderInfo.limit)
      return; //TODO display message*/

    Future<bool> success = ServerApi().placeOrder(basketData);
    if(await success == false)
      return; //display message that request to server failed

    basketData.clear();

    Navigator.of(context).pushNamed('/succesfulOrder');
  }
}
