import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: OrderingTools(),
          ),
          Flexible(
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

class OrderingTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BottomMenuButton("Food", Icons.fastfood, Colors.grey[300], (){}), //TODO implement callback
        BottomMenuButton("Price", Icons.attach_money,Colors.grey[300], (){}) ,//TODO implement callback
        BottomMenuButton("Add", Icons.add_shopping_cart,Colors.green[300], (){}) ,//TODO implement callback
      ],
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressedCallBack;
  final IconData _icon;
  final Color _color;
  BottomMenuButton(this._text, this._icon, this._color, this._onPressedCallBack);

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
              color: _color,
              icon: Icon(_icon),
              label: Text(_text),
              onPressed: _onPressedCallBack,
            ),
          ),
        ),
      ),
    );
  }
}
