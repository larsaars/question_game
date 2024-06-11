import 'package:flutter/material.dart';

class NavigationUtils {
  static final routeObserver = RouteObserver<PageRoute>();

  /// pops the current route as soon as possible
  static void popWhenPossible(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  ///pushes new route as soon as possible
  static void pushNamedWhenPossible(BuildContext context, String routeName, {Object? arguments}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    });
  }

  /// Pushes a new route and removes all other routes from the stack
  /// except the main route
  static void pushNamedAndPopTillMain(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => route.isFirst);
    });
  }

  static void popTillMain(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
