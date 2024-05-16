import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:question_game/ui/routes/choose_categories.dart';
import 'package:question_game/ui/routes/current_players.dart';
import 'package:question_game/ui/routes/home_page.dart';
import 'package:question_game/ui/ui_defaults.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized(); // register pwa class
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  // register licenses directly on start
  registerLicenses();
  // start app
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
        colorScheme: ColorScheme.fromSeed(seedColor: UIDefaults.colorPrimary),
        iconTheme: const IconThemeData(
          color: UIDefaults.colorDefaultIcon,
          size: UIDefaults.defaultIconSize,
        ),
        useMaterial3: true,
        fontFamily: 'louis_george_cafe',
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (var type in TargetPlatform.values)
              type: const FadeUpwardsPageTransitionsBuilder()
          },
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),  // floating action buttons are round
          ),
        ),
      ),
      routes: {
        '/': (context) => const MyHomePage(),
        '/categories': (context) => const ChooseCategoriesPage(),
        '/current-players': (context) => const CurrentPlayersPage(),
      },
    );
  }
}
