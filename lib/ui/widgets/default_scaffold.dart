import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart';

// default scaffold as outermost widget to embed other widgets
// contains a back button and a child widget
class DefaultScaffold extends StatelessWidget {
  // child widget to be displayed in the scaffold
  final Widget child;
  // action button to be displayed in the bottom right corner (null if none)
  final Widget? actionButton;
  // widget that can be displayed on the top right corner
  // on the same height as the back button
  final Widget? topRightWidget;
  // (gets padding of one default icon size per default)
  final double topRightWidgetWidth;
  // title of the scaffold
  final String? title;
  // if is back button or app icon with dropdown menu
  final bool backButton;
  // if view should be cut off at the action button
  // or if the action buttons float over the view
  final bool cutOffAtActionButton;

  const DefaultScaffold({
    super.key,
    required this.child,
    this.title,
    this.backButton = true,
    this.cutOffAtActionButton = false,
    this.actionButton,
    this.topRightWidget,
    this.topRightWidgetWidth = UIDefaults.defaultIconSize,
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
    if (screenWidth < 820) {
      return [0.0, 0.0];
    } else {
      // if is a large screen, set padding
      // relative to size of screen
      return [
        screenWidth * 0.24,
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
          Padding( // content in padding with fab
            padding: EdgeInsets.only(
              // ensure padding is at least as wide as the icon on the left
              left: max(UIDefaults.defaultIconSize, horizontalPadding),
              right: max(topRightWidget == null ? 0 : topRightWidgetWidth, horizontalPadding),
              top: verticalPadding,
              bottom: verticalPadding,
            ),
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: UIDefaults.colorPrimary,
                            ),
                      ),
                    ),
                  Expanded(
                    child: child,
                  ),
                  if (cutOffAtActionButton)
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
          Align( // align with back button top left
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
          if (topRightWidget != null)
            Align( // align with top right widget
              alignment: Alignment.topRight,
              child: topRightWidget!,
            ),
        ],
      ),
    );
  }
}
