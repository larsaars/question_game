import 'dart:ui';

import 'package:question_game/utils/base_utils.dart';

class UIUtils {
  static Color createRandomPastelBackgroundColor() {
    return Color((BaseUtils.random.nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(0.05);
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
