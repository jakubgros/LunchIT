import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            Logout(),
          ],
          title: Text("List of order requests"),
        ),
          body: FutureBuilder<List<OrderRequest>>(
            future: ServerApi().getOrderRequests(),
            builder: (BuildContext context, AsyncSnapshot<List<OrderRequest>> snapshot) {
              return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                itemBuilder: (BuildContext context, int index) => OrderRequestPresenter(snapshot.data[index]),
              );
            }
          )),
    );
  }
}

class Logout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(

        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: (){
                  Navigator.of(context).pushNamed('/login');
                  ServerApi().logout();
                },
              ),
              Text("Logout"),
            ],
          ),
        )
    );
  }
}

class OrderRequestPresenter extends StatelessWidget {
  final OrderRequest orderRequest;

  const OrderRequestPresenter(this.orderRequest);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if(orderRequest.isOrdered) {
            Provider.of<OrderRequest>(context).assign(orderRequest);
            Navigator.of(context).pushNamed('/orderDataPresenter', arguments: orderRequest);
          }
          else if(!orderRequest.hasExpired()){
            Provider.of<OrderRequest>(context).assign(orderRequest);
            Navigator.of(context).pushNamed('/foodPicker', arguments: orderRequest);
          }
        },
        child: Card(
          color: orderRequest.canOrder() ? Colors.red[200] : Colors.green[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(orderRequest.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if(orderRequest.message != null) Text(orderRequest.message),
                Divider(color: Colors.black,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DescriptionAndValue("Price limit: ", "${orderRequest.priceLimit.toStringAsFixed(2)}"),
                        DescriptionAndValue("Status: ", "${orderRequest.isOrdered ? "Ordered" : "Not ordered"}"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        DescriptionAndValue("Deadline: ", "${orderRequest.deadlineAsFormattedStr}"),
                        if(!orderRequest.isOrdered) DescriptionAndValue("Time left: ", "${orderRequest.timeLeftAsFormattedString}")
                      ],
                    )
                  ],
                ),

              ],
            ),
          ),
        )
    );
  }
}


class BoldText extends StatelessWidget {
  final String text;

  BoldText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ));
  }
}

class DescriptionAndValue extends StatelessWidget {
  final String description;
  final String value;

  DescriptionAndValue(this.description, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(description),
        BoldText(value),
      ],
    );
  }
}

