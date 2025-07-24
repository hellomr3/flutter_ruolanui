import 'package:flutter/material.dart';

class ConditionalBuilder extends StatelessWidget {
  final bool condition;
  final WidgetBuilder trueBuilder;
  final WidgetBuilder? falseBuilder;

  const ConditionalBuilder({
    Key? key,
    required this.condition,
    required this.trueBuilder,
    this.falseBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return condition
        ? trueBuilder(context)
        : falseBuilder != null
        ? falseBuilder!(context)
        : SizedBox.shrink();
  }
}
