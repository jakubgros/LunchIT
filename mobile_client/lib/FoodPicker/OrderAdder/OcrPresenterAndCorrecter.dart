import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OcrPresenterAndCorrecter extends StatelessWidget {
  final Image image;
  final Future<String> imageAsText;
  final FormFieldValidator<String> validator;
  final void Function(String) onSaved;

  OcrPresenterAndCorrecter({
    @required this.image,
    @required this.imageAsText,
    @required this.onSaved,
    @required this.validator,
  });

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[300],
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            image,
            FutureBuilder<String>(
                future: imageAsText,
                initialData: "",
                builder: (context, snapshot) {
                  return TextFormField(
                    key: ValueKey(snapshot.data),
                    onSaved: onSaved,
                    initialValue: snapshot.data,
                    maxLines: null,
                    validator: validator,
                  );
                })
          ]),
        ),
      );

}
