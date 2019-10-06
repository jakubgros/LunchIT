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
              child: CashInfoBar()
          )
        ],
      ),
    );
  }
}

class CashInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suma: 100zl", //TODO dehardcode
                  textAlign: TextAlign.start,),
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Pozostalo: 20zl", //TODO dehardcode
                  textAlign: TextAlign.end,),
              ),
            )),
      ],
    );
  }
}

class OrderingTools extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RaisedButton(
            child: Text("Food"),
          ),
        ),
        Expanded(
          flex: 1,
          child: RaisedButton(
            child: Text("Price"),
          ),
        ),
        Expanded(
          flex: 1,
          child: RaisedButton(
            child: Text("Add"),
          ),
        ),
      ],
    );
  }
}
