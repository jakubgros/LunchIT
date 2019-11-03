import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuantityManager extends StatefulWidget {
  final FormFieldSetter<String> onSaved;
  final ValueChanged<int> onChanged;
  final int initVal;

  QuantityManager({this.onSaved, this.onChanged, this.initVal = 1});

  @override
  _QuantityManagerState createState() => _QuantityManagerState();
}

class _QuantityManagerState extends State<QuantityManager> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initVal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 30,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
          ),
            controller: _controller,
            onSaved: widget.onSaved,
            autovalidate: true,
            maxLines: 1,
            readOnly: true,
          ),
        ),
        Container(
          width: 50,
          child: RaisedButton(

            child: Icon(Icons.add),
            onPressed: _increaseQuantity,
          ),
        ),
        Container(
          width: 50,
          child: RaisedButton(
            child: Icon(Icons.remove),
            onPressed: _decreaseQuantity,
          ),
        ),
      ],
    );
  }
  
  void _increaseQuantity() {
    String value = _controller.text;
    int valAsInt = int.parse(value);
    ++valAsInt;

    _controller.text = valAsInt.toString();

    if(widget.onChanged != null)
      widget.onChanged(valAsInt);
  }

  void _decreaseQuantity() {
    String value = _controller.text;
    int valAsInt = int.parse(value);

    if (valAsInt <= 1) // doesn't make sense to decrease the value
      return;

    --valAsInt;
    _controller.text = valAsInt.toString();

    if(widget.onChanged != null)
      widget.onChanged(valAsInt);
  }
}
