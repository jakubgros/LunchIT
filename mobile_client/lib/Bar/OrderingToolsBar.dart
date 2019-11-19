import 'package:flutter/material.dart';
import 'package:lunch_it/Components/Marker/MarkerData.dart';
import 'package:lunch_it/EventStreams/AcceptMarkedEventStream.dart';
import 'package:lunch_it/EventStreams/MarkerModeEventStream.dart';
import 'package:lunch_it/Routes.dart';
import 'package:lunch_it/Utilities/Utils.dart';
import 'package:provider/provider.dart';

import '../Button/Button.dart';

class OrderingToolsBar extends StatefulWidget {
  @override
  _OrderingToolsBarState createState() => _OrderingToolsBarState();
}

class _OrderingToolsBarState extends State<OrderingToolsBar> {
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

  void _onPressAddCallback(BuildContext context) {
    MarkerData markerData = Provider.of<MarkerData>(context, listen: false);

    if (!markerData.hasFoodData || !markerData.hasPriceData) {
      displayInfoDialog(
          message: !markerData.hasFoodData ? "Food has not been marked" : "Price has not been marked",
          title: "Info",
          context: context,
          onPressOkCallback: () => Navigator.of(context).pop()
      );
      return;
    }
    Future hasAddedToBasket = Navigator.of(context)
        .pushNamed(Routes.addMenuPositionPage);

    hasAddedToBasket.then((hasAdded) {
      if(hasAdded == true)
        markerData.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => _onPressAddCallback(context))),
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
