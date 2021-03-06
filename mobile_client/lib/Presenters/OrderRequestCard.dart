import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/OrderResponseBloc.dart';
import 'package:lunch_it/Bloc/OrderRequestBloc.dart';
import 'package:lunch_it/Bloc/PlacedOrderBloc.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/Routes.dart';
import 'package:lunch_it/Utilities/Widgets/DescriptionAndValue.dart';
import 'package:provider/provider.dart';

class OrderRequestCard extends StatelessWidget {
  final OrderRequestModel orderRequest;

  const OrderRequestCard(this.orderRequest);

  void _onTap(context) {
    if(orderRequest.isOrdered) {
      Provider.of<OrderResponseBloc>(context).setCurrentOrderRequest(orderRequest); //TODO I think it's not needed
      Provider.of<PlacedOrderBloc>(context).init(orderRequest);
      Navigator.of(context).pushNamed(Routes.orderDataPresenter);
    }
    else if(!orderRequest.hasExpired()){
      Provider.of<OrderResponseBloc>(context).setCurrentOrderRequest(orderRequest);
      Navigator.of(context).pushNamed(Routes.foodPicker, arguments: orderRequest);
    }
    else {
      //Do nothing, card is just for presenting order request
    }
  }

  @override
  Widget build(BuildContext context) {

    String statusMsg;
    Color statusMsgColor;
    if(orderRequest.isOrdered){
      statusMsg = "Ordered";
      statusMsgColor = Colors.green[500];
    }
    else {
      if(orderRequest.hasExpired()){
        statusMsg = "Deadline passed";
        statusMsgColor = Colors.grey[600];
      }
      else {
        statusMsg = "Not ordered";
        statusMsgColor = Colors.orange[500];
      }
    }


    return GestureDetector(
        onTap: () => _onTap(context),
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
                        DescriptionAndValue("Status: ", statusMsg,
                            valueColor: statusMsgColor),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        DescriptionAndValue("Deadline: ", "${orderRequest.deadlineAsFormattedStr}"),
                        if(!orderRequest.isOrdered && !orderRequest.hasExpired()) DescriptionAndValue("Time left: ", "${orderRequest.timeLeftAsFormattedString}")
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
