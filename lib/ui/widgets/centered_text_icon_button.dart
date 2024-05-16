import 'package:flutter/material.dart';
import 'package:question_game/ui/ui_defaults.dart';

class CenteredTextIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final double height, iconSize, textSidePadding;
  final Color iconColor, textColor;

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
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .fontSize,
                        color: textColor,
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
