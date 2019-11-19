import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/Appbar/LogoutButton.dart';
import 'package:lunch_it/Models/OrderRequestModel.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';
import 'package:provider/provider.dart';

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
                itemBuilder: (BuildContext context, int index) => OrderRequestPresenter(snapshot.data[index]),
              );
            }
          )),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(15, 15))),
          elevation: 10,
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
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
                        DescriptionAndValue("Status: ", "${orderRequest.isOrdered ? "Ordered" : "Not ordered"}",
                          valueColor: orderRequest.canOrder() ? Colors.red[500] : Colors.green[500]),
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
  final Color color;
  BoldText(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
      ));
  }
}

class DescriptionAndValue extends StatelessWidget {
  final String description;
  final String value;
  final Color valueColor;
  DescriptionAndValue(this.description, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(description),
        BoldText(value, color: valueColor),
      ],
    );
  }
}

