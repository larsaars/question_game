import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html;

import '../ui/ui_defaults.dart';

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

  /// Shows a toast message.
  ///
  /// The [message] parameter is the message to be displayed in the toast.
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      webBgColor: '#455a64',
      webPosition: 'left',
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Returns horizontal and vertical padding depending on screen size.
  ///
  /// The [context] parameter is the build context.
  /// The [forDefaultScaffold] parameter is an optional boolean that defaults to false.
  /// If [forDefaultScaffold] is true, the padding is at least as high as the back button.
  ///
  /// Returns a list of two doubles representing the horizontal and vertical padding.
  static List<double> determinePadding(BuildContext context,
      {bool forDefaultScaffold = false}) {
    // check if is on a small screen (width)
    // if so, limit content size
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // if is a small screen, set no padding
    if (screenWidth < 860) {
      return [0.0, 0.0];
    } else {
      // if is a large screen, set padding
      // relative to size of screen
      return [
        screenWidth * 0.24,
        // ensure padding is at least as high as back button (for default scaffold)
        forDefaultScaffold
            ? max(screenHeight * 0.04, UIDefaults.defaultIconSize)
            : screenHeight * 0.04
      ];
    }
  }

  /// Converts HTML content to a [Text] widget.
  ///
  /// The [htmlContent] parameter is the HTML content to be converted.
  /// The [defaultStyle] parameter is an optional [TextStyle] that defaults to an empty [TextStyle].
  ///
  /// Returns a [Text] widget that represents the HTML content.
  static Text htmlToTextWidget(
    String htmlContent, {
    TextStyle style = const TextStyle(),
    var textAlign = TextAlign.left,
    ValueKey? key,
  }) {
    final document = html_parser.parse(htmlContent);
    return Text.rich(
      _parseHtml(document.body!, style, []),
      textAlign: textAlign,
      key: key,
      style: style,
    );
  }

  /// Parses an HTML element and its children to a [TextSpan].
  ///
  /// The [element] parameter is the HTML element to be parsed.
  /// The [defaultStyle] parameter is the default [TextStyle] to be used.
  /// The [spans] parameter is a list of [TextSpan]s that will be populated with the parsed HTML.
  ///
  /// Returns a [TextSpan] that represents the parsed HTML.
  static TextSpan _parseHtml(
      html.Element element, TextStyle defaultStyle, List<TextSpan> spans) {
    for (var node in element.nodes) {
      if (node is html.Text) {
        spans.add(TextSpan(text: node.text));
      } else if (node is html.Element) {
        TextStyle style;
        if (node.localName == 'b') {
          style = defaultStyle.copyWith(fontWeight: FontWeight.bold);
        } else if (node.localName == 'i') {
          style = defaultStyle.copyWith(fontStyle: FontStyle.italic);
        } else {
          style = defaultStyle;
        }

        spans.add(TextSpan(
          children: [_parseHtml(node, defaultStyle, [])],
          style: style,
        ));
      }
    }

    return TextSpan(children: spans);
  }


  /// Sets the preferred device orientation to landscape mode.
  ///
  /// This method sets the preferred orientations to [DeviceOrientation.landscapeLeft]
  /// and [DeviceOrientation.landscapeRight], meaning the device should be used in
  /// landscape mode. This is an asynchronous operation and returns a [Future] that
  /// completes when the orientation is set.
  static Future<void> setPreferredOrientation() async {
    return await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
