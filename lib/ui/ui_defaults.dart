import 'package:flutter/material.dart';

import '../utils/ui_utils.dart';

/// The `UIDefaults` class contains the default UI settings for the application.
class UIDefaults {
  /// The default background color for the application.
  static final backgroundColor = UIUtils.createRandomPastelBackgroundColor();

  /// The primary color for the application.
  static const colorPrimary = Color(0xFFC2185B);

  /// The default text color for buttons in the application.
  static const colorDefaultButtonText = Colors.black;

  /// The default color for icons in the application.
  static const colorDefaultIcon = Colors.black;

  /// The color for 'Yes' options in the application.
  static const colorYes = Color(0xf003d33f);

  /// The color for 'No' options in the application.
  static const colorNo = Color(0xf7f0000f);

  /// The color for body text in the game.
  static const colorGameBodyText = Color(0xff455a64);

  /// The default size for icons in the application.
  static const defaultIconSize = 36.0;

  /// The default height for buttons in the application.
  static const defaultButtonHeight = 48.0;

  /// The default text size for game titles in the application.
  static const gameTitleTextSize = 51.0;

  /// The default text size for body text in the game.
  static const gameBodyTextSize = 23.4;

  /// The default text style for body text in the game.
  static const gameBodyTextStyle = TextStyle(
    color: UIDefaults.colorGameBodyText,
    fontSize: UIDefaults.gameBodyTextSize,
  );
}
