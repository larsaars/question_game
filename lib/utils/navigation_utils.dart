import 'package:flutter/material.dart';

class NavigationUtils {
  /// Pushes a new route and removes all other routes from the stack
  /// except the main route
  static void pushNamedAndPopTillMain(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => route.isFirst);
  }
}
