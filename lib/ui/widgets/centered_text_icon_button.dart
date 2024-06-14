import 'package:flutter/material.dart';
import 'package:question_game/ui/ui_defaults.dart';

/// A custom widget that displays an icon and a text in a centered alignment.
/// The icon is displayed to the left of the text.
/// The widget is a button that triggers a callback when pressed.
class CenteredTextIconButton extends StatelessWidget {
  /// The text to be displayed.
  final String text;

  /// The icon to be displayed.
  final IconData icon;

  /// The callback to be triggered when the button is pressed.
  final VoidCallback onPressed;

  /// The height of the button.
  final double height;

  /// The size of the icon.
  final double iconSize;

  /// The padding on the sides of the text.
  final double textSidePadding;

  /// The color of the icon.
  final Color iconColor;

  /// The color of the text.
  final Color textColor;

  /// Creates a new instance of the widget.
  ///
  /// The [icon], [text], and [onPressed] arguments are required.
  /// The [iconColor], [textColor], [height], [iconSize], and [textSidePadding] arguments are optional.
  const CenteredTextIconButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconColor = UIDefaults.colorDefaultIcon,
    this.textColor = UIDefaults.colorDefaultButtonText,
    this.height = UIDefaults.defaultButtonHeight,
    this.iconSize = UIDefaults.defaultIconSize,
    this.textSidePadding = UIDefaults.defaultButtonHeight,
  });

  /// Builds the widget.
  ///
  /// The widget is composed of an [ElevatedButton] that contains a [Stack].
  /// The [Stack] contains an [Icon] and a [Row] with the text.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: textSidePadding,
                    ),
                    Flexible(
                      child: Text(
                        text,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: textColor,
                                ),
                      ),
                    ),
                    SizedBox(
                      width: textSidePadding,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}