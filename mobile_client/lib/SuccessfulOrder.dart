import 'package:flutter/material.dart';

class SuccessfulOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(), //to remove go back icon
          title: Text("#MAIL TITLE#"), //TODO dehardcode
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text("Successful order"),
                RaisedButton(
                  child: Text("Click here to go to home page"),
                  onPressed: () => Navigator.of(context).pushNamed('/home'),
                )
            ],
          ),
        ));
  }
}


