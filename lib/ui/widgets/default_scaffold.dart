import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart';

// default scaffold as outermost widget to embed other widgets
// contains a back button and a child widget
class DefaultScaffold extends StatelessWidget {
  final Widget child;
  final Widget? actionButton;
  final String? title;
  final bool backButton;
  final bool cutAtActionButton;

  const DefaultScaffold({
    super.key,
    required this.child,
    this.title,
    this.backButton = true,
    this.cutAtActionButton = true,
    this.actionButton,
  });

  // prompt installing as PWA if is enabled
  void _promptInstallPWA() {
    final installer = PWAInstall();
    if (installer.installPromptEnabled) {
      installer.promptInstall_();
    }
  }

  List<double> _determinePadding(BuildContext context) {
    // return horizontal and vertical padding
    // check if is on a small screen (width)
    // if so, limit content size
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // if is a small screen, set no padding
    if (screenWidth < 600) {
      return [0.0, 0.0];
    } else {
      // if is a large screen, set padding
      // relative to size of screen
      return [
        screenWidth * 0.25,
        max(screenHeight * 0.04, UIDefaults.defaultIconSize),
        // ensure padding is at least as high as back button
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final [horizontalPadding, verticalPadding] = _determinePadding(context);

    return Scaffold(
      backgroundColor: UIDefaults.backgroundColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              // ensure padding is at least as wide as the icon on the left
              left: max(UIDefaults.defaultIconSize, horizontalPadding),
              right: horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding,
            ),
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: UIDefaults.colorPrimary,
                          ),
                    ),
                  Expanded(
                    child: child,
                  ),
                  if (cutAtActionButton)
                    const SizedBox(
                      height: 58.0,
                    )
                ],
              ),
              if (actionButton != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: actionButton,
                  ),
                ),
            ]),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Hero(
              tag: 'default-scaffold-button',
              child: backButton
                  // if is back button, show back button
                  ? IconButton(
                      tooltip: loc!.defaultScaffoldBack,
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: Navigator.of(context).pop,
                    )
                  // if is not back button, show app icon with dropdown menu
                  // showing about and install PWA (if available)
                  : Material(
                      shape: const CircleBorder(),
                      child: PopupMenuButton(
                        tooltip: loc!.appTitle,
                        offset: const Offset(
                          UIDefaults.defaultIconSize / 2,
                          UIDefaults.defaultIconSize / 2,
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'about',
                              child: Text(loc.defaultScaffoldAbout),
                            ),
                            // if PWA install is enabled, show install button
                            if (PWAInstall().installPromptEnabled)
                              PopupMenuItem<String>(
                                value: 'install',
                                child: Text(loc.defaultScaffoldInstall),
                              ),
                          ];
                        },
                        onSelected: (String value) {
                          if (value == 'about') {
                            showMyAboutDialog(context);
                          } else if (value == 'install') {
                            _promptInstallPWA();
                          }
                        },
                        icon: Image.asset(
                          'imgs/app_icon.png',
                          height: UIDefaults.defaultIconSize,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
