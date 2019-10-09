import 'package:flutter/material.dart';

class BottomMenuButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressedCallBack;
  final IconData _icon;
  final Color _releasedColor;
  final Color _pressedColor;
  final bool _isPressed;

  BottomMenuButton(this._text, this._icon, this._releasedColor, this._pressedColor,
      this._isPressed, this._onPressedCallBack);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.3),
        ),
        child: Material(
          child:  InkWell(
            child: RaisedButton.icon(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: _isPressed?_pressedColor:_releasedColor,
              icon: Icon(_icon),
              label: Text(_text),
              onPressed: _onPressedCallBack,
            ),
          ),
        ),
      ),
    );
  }
}
