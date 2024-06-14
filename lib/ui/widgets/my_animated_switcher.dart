import 'package:flutter/material.dart';

/// Enum for defining the type of transition to be used in [MyAnimatedSwitcher].
enum MyAnimatedSwitcherTransitionType { scale, fade, slide }

/// A custom widget that wraps the [AnimatedSwitcher] widget.
/// It allows for different types of transitions: scale, fade, and slide.
class MyAnimatedSwitcher extends StatelessWidget {
  /// The child widget to be displayed.
  final Widget child;

  /// The type of transition to be used.
  final MyAnimatedSwitcherTransitionType transitionType;

  /// Creates a new instance of the widget.
  ///
  /// The [child] argument is required.
  /// The [transitionType] argument is optional and defaults to [MyAnimatedSwitcherTransitionType.scale].
  const MyAnimatedSwitcher({
    super.key,
    required this.child,
    this.transitionType = MyAnimatedSwitcherTransitionType.scale,
  });

  /// Builds the widget.
  ///
  /// The widget is composed of an [AnimatedSwitcher] that contains the child widget.
  /// The transition of the [AnimatedSwitcher] is determined by the [transitionType].
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