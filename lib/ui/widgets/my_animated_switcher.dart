import 'package:flutter/material.dart';

enum MyAnimatedSwitcherTransitionType { scale, fade, slide }

class MyAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final MyAnimatedSwitcherTransitionType transitionType;

  const MyAnimatedSwitcher({
    super.key,
    required this.child,
    this.transitionType = MyAnimatedSwitcherTransitionType.scale,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        switch (transitionType) {
          case MyAnimatedSwitcherTransitionType.scale:
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          case MyAnimatedSwitcherTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case MyAnimatedSwitcherTransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
        }
      },
      child: child,
    );
  }
}