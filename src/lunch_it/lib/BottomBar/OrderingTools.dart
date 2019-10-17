import 'package:flutter/material.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeBloc.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkEvent.dart';

import 'BottomBarButton.dart';


class OrderingTools extends StatefulWidget {
  @override
  _OrderingToolsState createState() => _OrderingToolsState();
}

class _OrderingToolsState extends State<OrderingTools> {
  MarkModeBloc _bloc;
  bool _isFoodPressed;
  bool _isPricePressed;

  void _onToggleFoodCallback(){
    setState((){
      _isPricePressed = false;

      if(_isFoodPressed) {
        _isFoodPressed = false;
        _bloc.event.add(NavigateEvent());
      } else {
        _isFoodPressed = true;
        _bloc.event.add(MarkFoodEvent());
      }
    });
  }

  void _onTogglePriceCallback(){
    setState((){
      _isFoodPressed = false;

      if(_isPricePressed) {
        _isPricePressed = false;
        _bloc.event.add(NavigateEvent());
      } else {
        _isPricePressed = true;
        _bloc.event.add(MarkPriceEvent());
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
            child: BottomMenuButton(
            "Food", Icons.fastfood, Colors.grey[300], Colors.grey[400],
            _isFoodPressed, _onToggleFoodCallback)),
        Expanded(
            flex: 3,
            child: BottomMenuButton(
            "Price", Icons.attach_money, Colors.grey[300], Colors.grey[400],
            _isPricePressed, _onTogglePriceCallback)),
        Expanded(
            flex: 2,
            child: BottomMenuButton(
            "Add", Icons.add_shopping_cart, Colors.green[300], null,
            false, () {
          /*TODO put hero here which displays current*/
        })),

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
    _isFoodPressed = false;
    _isPricePressed = false;
  }
}
