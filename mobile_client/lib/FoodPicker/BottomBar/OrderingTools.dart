import 'package:flutter/material.dart';
import 'package:lunch_it/FoodPicker/EventStreams/AcceptMarked.dart';
import 'package:lunch_it/FoodPicker/EventStreams/MarkerMode.dart';
import 'package:lunch_it/FoodPicker/Marker/MarkerData.dart';
import 'package:provider/provider.dart';

import 'Button.dart';

class OrderingTools extends StatefulWidget {
  @override
  _OrderingToolsState createState() => _OrderingToolsState();
}

class _OrderingToolsState extends State<OrderingTools> {
  AcceptMarkedEventStream _acceptMarkedEventStream;
  MarkerModeEventStream _markerModeEventStream;

  bool _isFoodPressed;
  bool _isPricePressed;

  void _onToggleFoodCallback() {
    setState(() {
      _isPricePressed = false;

      if (_isFoodPressed) {
        _isFoodPressed = false;
        _markerModeEventStream.sink.add(MarkerModeEvent.navigate());
        _acceptMarkedEventStream.sink.add(AcceptMarkedEvent.markedFood());
      } else {
        _isFoodPressed = true;
        _markerModeEventStream.sink.add(MarkerModeEvent.markFood());
      }
    });
  }

  void _onTogglePriceCallback() {
    setState(() {
      _isFoodPressed = false;

      if (_isPricePressed) {
        _isPricePressed = false;
        _markerModeEventStream.sink.add(MarkerModeEvent.navigate());
        _acceptMarkedEventStream.sink.add(AcceptMarkedEvent.markedPrice());
      } else {
        _isPricePressed = true;
        _markerModeEventStream.sink.add(MarkerModeEvent.markPrice());
      }
    });
  }

  void _onPressAddCallback() {
    MarkerData markerData = Provider.of<MarkerData>(context, listen: false);

    if (!markerData.hasFoodData || !markerData.hasPriceData)
      return; //TODO display notification

    Future hasAddedToBasket = Navigator.of(context)
        .pushNamed('/foodPicker/addMenuPositionPage');

    hasAddedToBasket.then((hasAdded) {
      if(hasAdded == true)
        markerData.reset();
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
                onPressed: _onPressAddCallback)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _isFoodPressed = false;
    _isPricePressed = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _acceptMarkedEventStream = Provider.of<AcceptMarkedEventStream>(context, listen: false);
    _markerModeEventStream = Provider.of<MarkerModeEventStream>(context, listen: false);
  }


}
