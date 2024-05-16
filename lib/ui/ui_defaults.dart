import 'package:flutter/material.dart';
import 'package:question_game/utils/ui_utils.dart';


class UIDefaults {
  static final backgroundColor = UIUtils.createRandomPastelBackgroundColor();

  static const colorPrimary = Color(0xFFC2185B),
      colorDefaultButtonText = Colors.black,
      colorDefaultIcon = Colors.black,
      colorYes = Color(0xf003d33f),
      colorNo = Color(0xf7f0000f),
      colorSubQuestionText = Color(0xff455a64);

  static const defaultIconSize = 36.0,
      defaultButtonHeight = 48.0;
}