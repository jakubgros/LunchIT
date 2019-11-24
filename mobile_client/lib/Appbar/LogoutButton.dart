import 'package:flutter/material.dart';
import 'package:lunch_it/Button/LabeledIconButton.dart';
import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/Routes.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LabeledIconButton(
      label: Text("Logout"),
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.login);
        ServerApi().logout();
      },
    );
  }
}
