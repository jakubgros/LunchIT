import 'package:flutter/widgets.dart';
import 'package:lunch_it/Utilities/Widgets/BoldText.dart';

class DescriptionAndValue extends StatelessWidget {
  final String description;
  final String value;
  final Color valueColor;
  DescriptionAndValue(this.description, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(description),
        BoldText(value, color: valueColor),
      ],
    );
  }
}
