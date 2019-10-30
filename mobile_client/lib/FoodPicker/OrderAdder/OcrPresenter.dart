import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class OcrPresenterCorrecter extends StatelessWidget {
  final Image _image;
  final Future<String> _imageAsText;
  final FormFieldValidator<String> _validator;
  String _fieldValue;
  String _ocrValue;

  OcrPresenterCorrecter({
    @required Image image,
    @required Future<String> text,
    FormFieldValidator<String> validator,
  })  : _image = image,
        _imageAsText = text,
        _validator = validator;

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[300],
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: _image,
            ),
            FutureBuilder<String>(
                future: _imageAsText,
                initialData: "",
                builder: (context, snapshot) {
                  _ocrValue = snapshot.data;
                  return TextFormField(
                    onChanged: (value) => _fieldValue = value,
                    key: ValueKey(snapshot.data),
                    initialValue: snapshot.data,
                    maxLines: null,
                    validator: _validator,
                  );
                })
          ]),
        ),
      );

  String get value => _fieldValue ?? _ocrValue;
}
