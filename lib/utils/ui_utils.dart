import 'dart:ui';

import 'package:question_game/utils/base_utils.dart';

/// A utility class that provides various UI related methods.
class UIUtils {
  /// Generates a random pastel color.
  ///
  /// This method generates a random color with a low opacity,
  /// which gives it a pastel-like appearance.
  ///
  /// Returns a [Color] object with a random RGB value and an opacity of 0.05.
  static Color createRandomPastelBackgroundColor() {
    return Color((BaseUtils.random.nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(0.05);
  }

  /// Converts a hexadecimal color code to a [Color] object.
  ///
  /// The [code] parameter is a hexadecimal color code as a string.
  /// The '#' character at the start of the string is not necessary.
  ///
  /// Returns a [Color] object that corresponds to the provided hexadecimal color code.
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// Beautifies a list of strings for displaying.
  /// Brings for example a list of ['Alice', 'Bob', 'Charlie'] to 'Alice, Bob & Charlie'.
  ///
  /// The [strings] parameter is a list of strings to be beautified.
  /// The [limitOfShownStrings] parameter is an optional parameter that limits the number of strings to be shown.
  /// If [limitOfShownStrings] is not provided, it defaults to 3.
  /// The [moreWord] parameter is an optional parameter that is used to indicate that there are more strings.
  ///
  /// Returns a string that is a beautified version of the input list.
  static String beautifyStringListForDisplaying(List<String> strings,
      {limitOfShownStrings = 3, moreWord = 'more'}) {
    final len = strings.length;

    if (len == 0) {
      return '';
    }

    var beautified = strings[0];

    for (var i = 1; i < len; i++) {
      if (i == len - 1) {
        beautified += ' & ${strings[i]}';
      } else if (i == limitOfShownStrings) {
        final stringsLeft = len - limitOfShownStrings;
        if (stringsLeft == 1) {
          beautified += ' & ${strings[i]}';
        } else {
          beautified += ' & $stringsLeft $moreWord';
        }
        break;
      } else {
        beautified += ', ${strings[i]}';
      }
    }

    return beautified;
  }
}
