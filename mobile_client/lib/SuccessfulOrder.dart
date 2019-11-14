import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/OrderRequestModel.dart';

class SuccessfulOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String title = Provider.of<OrderRequest>(context).title;
    
    return Scaffold(
        appBar: AppBar(
          leading: Container(), //to remove go back icon
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text("Successful order"),
                RaisedButton(
                  child: Text("Click here to go to home page"),
                  onPressed: () => Navigator.of(context).pushNamed('/home'),
                )
            ],
          ),
        ));
  }
}


