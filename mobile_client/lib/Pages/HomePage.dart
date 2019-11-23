import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/Appbar/LogoutButton.dart';
import 'package:lunch_it/Bloc/OrderRequestBloc.dart';
import 'package:lunch_it/Button/RefreshButton.dart';
import 'package:lunch_it/Presenters/OrderRequestCard.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var orderRequestBloc = Provider.of<OrderRequestBloc>(context);
    orderRequestBloc.update(); // needed because without it it would show requests of previous user when account changed
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: RefreshButton(onTap: orderRequestBloc.update),
          actions: <Widget>[
            LogoutButton(),
          ],
          title: Text("List of order requests"),
        ),
          body: StreamBuilder<List<OrderRequestModel>>(
            stream: orderRequestBloc.orderRequests,
            builder: (BuildContext context, AsyncSnapshot<List<OrderRequestModel>> snapshot) {
              return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                itemBuilder: (BuildContext context, int index) => OrderRequestCard(snapshot.data[index]),
              );
            }
          )),
    );
  }
}
