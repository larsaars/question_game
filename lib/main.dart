import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:question_game/ui/routes/home_page.dart';
import 'package:question_game/ui/ui_defaults.dart' as ui_defaults;

void main() {
  registerLicenses();
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
        colorScheme: ColorScheme.fromSeed(seedColor: ui_defaults.colorPrimary),
        iconTheme: const IconThemeData(
          color: ui_defaults.colorDefaultIcon,
          size: ui_defaults.defaultIconSize,
        ),
        useMaterial3: true,
        fontFamily: 'louis_george_cafe',
      ),
      routes: {
        '/': (context) => const MyHomePage(),
      },
    );
  }
}

