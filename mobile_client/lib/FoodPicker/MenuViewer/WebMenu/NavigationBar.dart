import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/FoodPicker/EventStreams/WebNavigation.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final webNavigationEventStream = Provider.of<WebNavigationEventStream>(context);

    return Material(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => webNavigationEventStream.sink.add(WebNavigationEvent.goBack()),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => webNavigationEventStream.sink.add(WebNavigationEvent.goForward()),
          ),
        ],
      ),
    );
  }
}
