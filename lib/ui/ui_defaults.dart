import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_install/pwa_install.dart';

Color createRandomPastelBackgroundColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
      .withOpacity(0.05);
}

final backgroundColor = createRandomPastelBackgroundColor();

const colorPrimary = Color(0xFFC2185B),
    colorDefaultButtonText = Colors.black,
    colorDefaultIcon = Colors.black,
    colorYes = Color(0xf003d33f),
    colorNo = Color(0xf7f0000f),
    colorSubQuestionText = Color(0xff455a64);

const defaultIconSize = 36.0, defaultButtonHeight = 48.0;

