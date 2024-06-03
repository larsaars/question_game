import 'package:flutter/material.dart';

class TextSwitcher extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const TextSwitcher(
    this.data, {
    super.key,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Text(
        data,
        style: style,
        key: ValueKey<String>(data),
      ),
    );
  }
}
