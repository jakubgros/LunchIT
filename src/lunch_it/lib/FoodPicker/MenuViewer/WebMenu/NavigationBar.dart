import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/Bloc/BlocProvider.dart';
import 'package:lunch_it/FoodPicker/Bloc/NavbarBloc/NavbarBloc.dart';
import 'package:lunch_it/FoodPicker/Bloc/NavbarBloc/NavbarBlocEvent.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavbarBloc navbarBloc = BlocProvider.of<NavbarBloc>(context);

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navbarBloc.event.add(NavbarGoBackEvent()), //TODO
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () => navbarBloc.event.add(NavbarGoForwardEvent()),
        ),
      ],
    );
  }
}
