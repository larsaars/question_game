import 'package:flutter/material.dart';

class MyAnimatedSwitcher extends StatelessWidget {
  final Widget child;

  const MyAnimatedSwitcher({
    super.key,
    required this.child,
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
      child: child,
    );
  }
}
