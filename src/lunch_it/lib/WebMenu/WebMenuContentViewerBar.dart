import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Bloc/BlocProvider.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBloc.dart';
import 'package:lunch_it/Bloc/NavbarBloc/NavbarBlocEvent.dart';

class WebMenuContentViewerBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    NavbarBloc navbarBloc = BlocProvider.of<NavbarBloc>(context);

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navbarBloc.event.add(NavbarGoBackEvent()),
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
