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
    colorSubQuestionText = Color(0xff455a64),
// category colors
    colorCategoryQuestion = colorPrimary,
    colorCategoryPoll = Color(0xff8BC34A),
    colorCategoryChallenge = Color(0xffFFEB3B),
    colorCategoryBomb = Color(0xffFFA726),
    colorCategoryRule = Color(0xff102027),
    colorCategoryYesOrNo = Color(0xff03A9F4),
    colorCategoryEtc = colorCategoryRule;

const defaultIconSize = 36.0, defaultButtonHeight = 48.0;

// default scaffold as outermost widget to embed other widgets
// contains a back button and a child widget
class DefaultScaffold extends StatelessWidget {
  final Widget child;
  final bool backButton;

  const DefaultScaffold({
    super.key,
    required this.child,
    this.backButton = true,
  });

  // prompt installing as PWA if is enabled
  void _promptInstallPWA() {
    final installer = PWAInstall();
    print(installer.installPromptEnabled);
    if (installer.installPromptEnabled) {
      installer.promptInstall_();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: defaultIconSize),
            child: child,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Hero(
              tag: 'default-scaffold-button',
              child: IconButton(
                tooltip: backButton ? loc!.defaultScaffoldBack : loc!.appTitle,
                icon: backButton
                    ? const Icon(Icons.arrow_back_ios_new)
                    : Image.asset(
                        'imgs/app_icon.png',
                        height: defaultIconSize,
                      ),
                onPressed: () =>
                    backButton ? Navigator.of(context).pop() : _promptInstallPWA(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
