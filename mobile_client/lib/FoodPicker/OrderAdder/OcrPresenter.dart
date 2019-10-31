import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OcrPresenterCorrecter extends StatelessWidget {
  final Image _image;
  final Future<String> _imageAsText;
  final FormFieldValidator<String> _validator;
  final void Function(String) _onValueChanged;

  OcrPresenterCorrecter({
    @required Image image,
    @required Future<String> text,
    @required void Function(String) onValueChanged,
    FormFieldValidator<String> validator,
  })  : _image = image,
        _imageAsText = text,
        _validator = validator,
        _onValueChanged = onValueChanged;

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[300],
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            _image,
            FutureBuilder<String>(
                future: _imageAsText,
                initialData: "",
                builder: (context, snapshot) {
                  _onValueChanged(snapshot.data);
                  return TextFormField(
                    onChanged: _onValueChanged,
                    key: ValueKey(snapshot.data),
                    initialValue: snapshot.data,
                    maxLines: null,
                    validator: _validator,
                  );
                })
          ]),
        ),
      );

}
