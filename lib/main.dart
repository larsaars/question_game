import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/ui_utils.dart' as ui_utils;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question Game',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ui_utils.colorPrimary),
        iconTheme: const IconThemeData(
          color: ui_utils.colorDefaultIcon,
          size: ui_utils.defaultIconSize,
        ),
        useMaterial3: true,
        fontFamily: 'louis_george_cafe',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui_utils.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: const TextStyle(
                        fontSize: 64,
                        fontFamily: 'alte_haas_grotesk',
                        fontWeight: FontWeight.w700,
                        color: ui_utils.colorPrimary,
                      ),
                    ),
                  ),
                  ui_utils.IconButton(
                    icon: Icons.videogame_asset,
                    text: AppLocalizations.of(context)!.mainScreenStartGame,
                    textColor: ui_utils.colorPrimary,
                    iconColor: ui_utils.colorPrimary,
                    onPressed: () {},
                  ),
                  ui_utils.IconButton(
                    icon: Icons.category,
                    text: AppLocalizations.of(context)!
                        .mainScreenChooseCategories,
                    onPressed: () {},
                  ),
                  ui_utils.IconButton(
                      icon: Icons.question_mark_outlined,
                      text: AppLocalizations.of(context)!.mainScreenAbout,
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'imgs/app_icon.png',
                width: ui_utils.defaultIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
