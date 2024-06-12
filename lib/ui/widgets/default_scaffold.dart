import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:question_game/utils/ui_utils.dart';

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

  // the back button icon
  final IconData backButtonIcon;

  // back button functionality
  final Function()? backButtonFunction;

  // back button tooltip
  final String? backButtonTooltip;

  // if view should be cut off at the action button
  // or if the action buttons float over the view
  final bool cutOffAtActionButton;

  const DefaultScaffold({
    super.key,
    required this.child,
    this.title,
    this.backButton = true,
    this.backButtonIcon = Icons.arrow_back_ios_new,
    this.backButtonFunction,
    this.backButtonTooltip,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final [horizontalPadding, verticalPadding] =
        UIUtils.determinePadding(context, forDefaultScaffold: true);

    return Scaffold(
      backgroundColor: UIDefaults.backgroundColor,
      body: Stack(
        children: <Widget>[
          Padding(
            // content in padding with fab
            padding: EdgeInsets.only(
              // ensure padding is at least as wide as the icon on the left
              left: max(UIDefaults.defaultIconSize, horizontalPadding),
              right: max(topRightWidget == null ? 0 : topRightWidgetWidth,
                  horizontalPadding),
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
          Align(
            // align with back button top left
            alignment: Alignment.topLeft,
            child: Hero(
              tag: 'default-scaffold-button',
              child: backButton
                  // if is back button, show back button
                  ? IconButton(
                      tooltip: backButtonTooltip ?? loc!.defaultScaffoldBack,
                      icon: Icon(backButtonIcon),
                      onPressed:
                          backButtonFunction ?? Navigator.of(context).pop,
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
            Align(
              // align with top right widget
              alignment: Alignment.topRight,
              child: topRightWidget!,
            ),
        ],
      ),
    );
  }
}
