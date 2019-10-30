import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class OcrPresenterCorrecter extends StatelessWidget {
  final File _imgFile;
  final FormFieldValidator<String> _validator;
  String _fieldValue;
  String _ocrValue;

  OcrPresenterCorrecter({
    @required File image,
              FormFieldValidator<String> validator,
  })  : _imgFile = image,
        _validator = validator;

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[300],
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Image.file(
              _imgFile,
              fit: BoxFit.scaleDown,
            ),
            FutureBuilder<String>(
                future: ServerApi().getAsText(_imgFile.path),
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
