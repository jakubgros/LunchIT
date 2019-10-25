import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/Bloc/BlocProvider.dart';
import 'package:lunch_it/FoodPicker/Bloc/MarkModeBloc/MarkEvent.dart';
import 'package:lunch_it/FoodPicker/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/FoodPicker/EventStreams/AcceptMarked.dart';
import 'package:provider/provider.dart';

import 'Button.dart';

class OrderingTools extends StatefulWidget {
  @override
  _OrderingToolsState createState() => _OrderingToolsState();
}

class _OrderingToolsState extends State<OrderingTools> {
  MarkModeBloc _markModeBloc;
  AcceptMarkedEventStream _acceptMarkedEventStream;

  bool _isFoodPressed;
  bool _isPricePressed;

  void _onToggleFoodCallback() {
    setState(() {
      _isPricePressed = false;

      if (_isFoodPressed) {
        _isFoodPressed = false;
        _markModeBloc.event.add(NavigateEvent());
        _acceptMarkedEventStream.sink.add(AcceptMarkedBlocEvent.markedFood());
      } else {
        _isFoodPressed = true;
        _markModeBloc.event.add(MarkFoodEvent());
      }
    });
  }

  void _onTogglePriceCallback() {
    setState(() {
      _isFoodPressed = false;

      if (_isPricePressed) {
        _isPricePressed = false;
        _markModeBloc.event.add(NavigateEvent());
        _acceptMarkedEventStream.sink.add(AcceptMarkedBlocEvent.markedPrice());
      } else {
        _isPricePressed = true;
        _markModeBloc.event.add(MarkPriceEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO lock buttons until the page is loaded
    return Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Button(
                description: "Food",
                icon: Icons.fastfood,
                defaultColor: Colors.grey[300],
                pressedColor: Colors.grey[400],
                isPressed: _isFoodPressed,
                onPressed: _onToggleFoodCallback)),
        Expanded(
            flex: 3,
            child: Button(
                description: "Price",
                icon: Icons.attach_money,
                defaultColor: Colors.grey[300],
                pressedColor: Colors.grey[400],
                isPressed: _isPricePressed,
                onPressed: _onTogglePriceCallback)),
        Expanded(
            flex: 2,
            child: Button(
                description: "Add",
                icon: Icons.add_shopping_cart,
                defaultColor: Colors.green[300],
                isPressed: false,
                onPressed: () {/*TODO put hero here which displays current*/
                })),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _markModeBloc = BlocProvider.of<MarkModeBloc>(context);

    _isFoodPressed = false;
    _isPricePressed = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /* listen set to false so as not to rebuild the widget since this widget
     is only emitting values to the stream*/
    _acceptMarkedEventStream = Provider.of<AcceptMarkedEventStream>(context, listen: false);
  }


}
