import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OcrPresenterAndCorrecter extends StatelessWidget {
  final Image image;
  final Future<String> imageAsText;
  final FormFieldValidator<String> validator;
  final void Function(String) onValueChanged;

  OcrPresenterAndCorrecter({
    @required this.image,
    @required this.imageAsText,
    @required this.onValueChanged,
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
                  onValueChanged(snapshot.data);
                  return TextFormField(
                    key: ValueKey(snapshot.data),
                    onChanged: onValueChanged,
                    initialValue: snapshot.data,
                    maxLines: null,
                    validator: validator,
                  );
                })
          ]),
        ),
      );

}
