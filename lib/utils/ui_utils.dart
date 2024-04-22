import 'dart:math';

import 'package:flutter/material.dart';

Color createRandomPastelBackgroundColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
      .withOpacity(0.2);
}

final backgroundColor = createRandomPastelBackgroundColor();

const colorPrimary = Color(0xFFC2185B),
    colorDefaultButtonText = Colors.black,
    colorDefaultIcon = Colors.black,
    colorYes = Color(0xf003d33f),
    colorNo = Color(0xf7f0000f),
    colorSubQuestionText = Color(0xff455a64),
    colorCategoryDefault = colorPrimary,
    colorCategoryPoll = Color(0xff8BC34A),
    colorCategoryChallenge = Color(0xffFFEB3B),
    colorCategoryBomb = Color(0xffFFA726),
    colorCategoryRule = Color(0xff102027),
    colorCategoryYesOrNo = Color(0xff03A9F4),
    colorCategoryEtc = colorCategoryRule;

const defaultIconSize = 36.0, defaultButtonHeight = 48.0;

class IconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final double height, iconSize, textSidePadding;
  final Color iconColor, textColor;

  const IconButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconColor = colorDefaultIcon,
    this.textColor = colorDefaultButtonText,
    this.height = defaultButtonHeight,
    this.iconSize = defaultIconSize,
    this.textSidePadding = defaultButtonHeight,
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
