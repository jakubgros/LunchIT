import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String _description;
  final IconData _icon;
  final Color _defaultColor;
  final Color _pressedColor;
  final bool _isPressed;
  final VoidCallback _onPressedCallBack;

  Button(
      {@required String description,
      @required IconData icon,
      @required Color defaultColor,
      Color pressedColor,
      @required bool isPressed,
      @required VoidCallback onPressed})
      : _description = description,
        _icon = icon,
        _defaultColor = defaultColor,
        _pressedColor = pressedColor == null ? defaultColor : pressedColor,
        _isPressed = isPressed,
        _onPressedCallBack = onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
      ),
      child: Material(
        child: InkWell(
          child: RaisedButton.icon(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: _isPressed ? _pressedColor : _defaultColor,
            icon: Icon(_icon),
            label: _isPressed ? Text("Accept") : Text(_description),
            onPressed: _onPressedCallBack,
          ),
        ),
      ),
    );
  }
}
