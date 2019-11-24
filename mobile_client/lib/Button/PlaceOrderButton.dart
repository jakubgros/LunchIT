import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/OrderResponseBloc.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/Routes.dart';
import 'package:lunch_it/Utilities/Utils.dart';
import 'package:provider/provider.dart';

class PlaceOrderButton extends StatefulWidget {
  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
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
            onPressed: () => _placeOrder(Navigator.of(context), Provider.of<OrderResponseBloc>(context, listen: false)),
          ),
        ),
      ],
    );
  }

  void _placeOrder(NavigatorState navigator, OrderResponseBloc basketBloc) async {
    Future<bool> success = basketBloc.placeOrder();

    if(await success == false) {
      displayInfoDialog(
          context: context,
          title: "Order failed!",
          message: "Uncrecognized error",
          onPressOkCallback: () => navigator.pop(),
      );
    }
    else {
      displayInfoDialog(
          context: context,
          title: "Success!",
          message: "Your order has been successfuly placed!",
          onPressOkCallback: () {
            navigator.pushNamed(Routes.home);
          }
      );
    }
  }
}
