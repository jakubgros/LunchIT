
import 'package:flutter/material.dart';
import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/Routes.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: (){
                  Navigator.of(context).pushNamed(Routes.login);
                  ServerApi().logout();
                },
              ),
              Text("Logout"),
            ],
          ),
        )
    );
  }
}
