import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuMarker extends StatelessWidget {
  File _screenshot;


  MenuMarker(this._screenshot);

  @override
  Widget build(BuildContext context) { //TODO remove decorated box, it's just for debug purposes
    return DecoratedBox(child: Image.file(_screenshot),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red[900],
          )
      ),);
  }
}
