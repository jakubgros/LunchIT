import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<OrderRequest>> _orderRequests;

  @override
  void initState() {
    super.initState();
    _orderRequests = ServerApi().getOrderRequests();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("List of order requests"),
        ),
          body: FutureBuilder<List<OrderRequest>>(
            future: _orderRequests,
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
                ),),
                Divider(color: Colors.black,),
                Row(
                  children: <Widget>[
                    Text("Price limit: ${orderRequest.priceLimit.toStringAsFixed(2)}"),
                    Spacer(),
                    Text("Deadline: ${_getDateAsFormattedString(orderRequest.deadline)}"),
                  ],
                )

              ],
            ),
          ),
        ) //TODO LN-57
    );
  }
}
