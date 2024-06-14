import 'package:flutter/material.dart';

/// A utility class for handling navigation in the application.
class NavigationUtils {
  /// An observer for route navigation.
  static final routeObserver = RouteObserver<PageRoute>();

  /// Pops the current route as soon as possible.
  /// This is done after the current frame callback, ensuring that the pop operation is done after the widget tree is built.
  static void popWhenPossible(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  /// Pushes a new route as soon as possible.
  /// This is done after the current frame callback, ensuring that the push operation is done after the widget tree is built.
  static void pushNamedWhenPossible(BuildContext context, String routeName, {Object? arguments}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    });
  }

  /// Pushes a new route and removes all other routes from the stack except the main route.
  /// This is done after the current frame callback, ensuring that the operation is done after the widget tree is built.
  static void pushNamedAndPopTillMain(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => route.isFirst);
    });
  }

  /// A flag used in the main game screen since didPopNext is called.
  static bool wantsToPopTillMain = false;

  /// Pops all routes until the main route from the game screen.
  /// This sets a flag to true and pops all routes until the main route.
  static void fromGamePopTillMain(BuildContext context) {
    // set the flag to true
    wantsToPopTillMain = true;
    // pop the current route until the main route
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}