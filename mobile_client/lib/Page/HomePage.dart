import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/Appbar/LogoutButton.dart';
import 'package:lunch_it/OrderRequest/OrderRequestCard.dart';
import 'package:lunch_it/OrderRequest/OrderRequestModel.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            LogoutButton(),
          ],
          title: Text("List of order requests"),
        ),
          body: FutureBuilder<List<OrderRequest>>(
            future: ServerApi().getOrderRequestsForCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<List<OrderRequest>> snapshot) {
              return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                itemBuilder: (BuildContext context, int index) => OrderRequestCard(snapshot.data[index]),
              );
            }
          )),
    );
  }
}
