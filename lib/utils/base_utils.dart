import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// A utility class that provides shared resources for the application.
class BaseUtils {
  /// A random number generator.
  static final Random random = Random();

  /// A reference to the shared preferences of the application.
  /// This can be used to persist data across app launches.
  static SharedPreferences? prefs;
}