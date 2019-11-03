import 'package:flutter/material.dart';

class SuccessfulOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(), //to remove go back icon
          title: Text("#MAIL TITLE#"), //TODO dehardcode
        ),
        body: Text("Successful order"));
  }
}


