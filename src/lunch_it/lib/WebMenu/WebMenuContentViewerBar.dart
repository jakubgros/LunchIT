import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WebMenuContentViewerBar extends StatelessWidget {

  final VoidCallback _goBackCallback;
  final VoidCallback _goForwardCallback;

  WebMenuContentViewerBar(this._goBackCallback, this._goForwardCallback);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _goBackCallback,
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _goForwardCallback,
        ),
      ],
    );
  }

}
