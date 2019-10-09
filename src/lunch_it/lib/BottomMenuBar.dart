import 'package:flutter/material.dart';

import 'mark_mode_bloc.dart';

class BottomMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: OrderingTools(),
          ),
          Expanded(
              flex: 1,
              child: CashInfoBar(12.34, 56.78) //TODO dehardcode
          )
        ],
      ),
    );
  }
}

class CashInfoBar extends StatelessWidget {
  final double _moneySpent;
  final double _moneyLeft;

  CashInfoBar(this._moneySpent, this._moneyLeft);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.blue[700]
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Suma: ${_moneySpent.toStringAsFixed(2)} zl",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Pozostalo: ${_moneyLeft.toStringAsFixed(2)} zl",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white,)),
                ),
              )),
        ],
      ),
    );
  }
}

class OrderingTools extends StatefulWidget {
  @override
  _OrderingToolsState createState() => _OrderingToolsState();
}

class _OrderingToolsState extends State<OrderingTools> {
  MarkModeBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BottomMenuButton("Food", Icons.fastfood, Colors.grey[300], Colors.grey[400], true, (){_bloc.event.add(MarkFoodEvent());}),
        BottomMenuButton("Price", Icons.attach_money,Colors.grey[300], Colors.grey[400], true, (){_bloc.event.add(MarkPriceEvent());}),
        BottomMenuButton("Add", Icons.add_shopping_cart,Colors.green[300], Colors.grey[400], false, (){/*TODO*/}),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkModeBloc>(context);
  }
}

class BottomMenuButton extends StatefulWidget {
  final String _text;
  final VoidCallback _onPressedCallBack;
  final IconData _icon;
  final Color _released;
  final Color _pressed;
  final bool _isTogglable;


  BottomMenuButton(this._text, this._icon, this._released, this._pressed,
      this._isTogglable, this._onPressedCallBack);

  @override
  _BottomMenuButtonState createState() => _BottomMenuButtonState();
}

class _BottomMenuButtonState extends State<BottomMenuButton> {



  bool isPressed = false;

  void toggle(){
    isPressed = !isPressed;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.3),
        ),
        child: Material(
          child:  InkWell(
            child: RaisedButton.icon(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: isPressed?widget._pressed:widget._released,
              icon: Icon(widget._icon),
              label: Text(widget._text),
              onPressed: (){
                if(widget._isTogglable)
                  setState((){toggle();});
                widget._onPressedCallBack();},
            ),
          ),
        ),
      ),
    );
  }
}

