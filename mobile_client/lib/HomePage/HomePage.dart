import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

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



class OrderRequestPresenter extends StatelessWidget {
  final OrderRequest orderRequest;

  const OrderRequestPresenter(this.orderRequest);

  String _getWithFollowingZeroIfNeeded(int val) {
    if(val<10)
      return "0$val";
    else
      return "$val";
  }
  String _getDateAsFormattedString(DateTime d){
    String year = d.year.toString();
    String month = _getWithFollowingZeroIfNeeded(d.month);
    String day = _getWithFollowingZeroIfNeeded(d.day);
    String hour = _getWithFollowingZeroIfNeeded(d.hour);
    String minute = _getWithFollowingZeroIfNeeded(d.minute);
    return "$year-$month-$day $hour:$minute";
  }

  String _getTimeLeftAsFormattedString(Duration d){
    if(d.inDays > 0)
      return "${d.inDays} days";
    if(d.inHours > 0)
      return "${d.inHours} hours";
    if (d.inMinutes > 0)
      return "${d.inMinutes} minutes";
    else
      return "${d.inSeconds} seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if(orderRequest.isOrdered)
            Navigator.of(context).pushNamed('/orderDataPresenter', arguments: orderRequest);
          else if(!orderRequest.hasExpired())
            Navigator.of(context).pushNamed('/foodPicker', arguments: orderRequest); //TODO LN-57 get data about request from navigator in foodPicker
        },
        child: Card(
          color: orderRequest.canOrder() ? Colors.green[200] : Colors.grey[500],
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
                        DescriptionAndValue("Deadline: ", "${_getDateAsFormattedString(orderRequest.deadline)}"),
                        if(!orderRequest.isOrdered) DescriptionAndValue("Time left: ", "${_getTimeLeftAsFormattedString(orderRequest.timeLeft)}")
                      ],
                    )
                  ],
                ),

              ],
            ),
          ),
        ) //TODO LN-57
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

