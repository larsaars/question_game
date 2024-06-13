import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:question_game/ui/routes/about.dart';
import 'package:question_game/ui/routes/choose_categories_page.dart';
import 'package:question_game/ui/routes/current_players_page.dart';
import 'package:question_game/ui/routes/game/game_bomb_page.dart';
import 'package:question_game/ui/routes/game/yesno/game_yes_no_page.dart';
import 'package:question_game/ui/routes/game/main_game_page.dart';
import 'package:question_game/ui/routes/game_selection/game_selection_page.dart';
import 'package:question_game/ui/routes/home_page.dart';
import 'package:question_game/ui/routes/game_selection/old_games_list_selection_page.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/navigation_utils.dart';
import 'package:question_game/utils/ui_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized(); // register pwa class
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  // register licenses directly on start
  registerLicenses();

  // add locales for timeago
  timeago.setLocaleMessages('de', timeago.DeMessages());

  // set preferred orientation
  UIUtils.setPreferredOrientation().then((_) {
    // then run the app
    runApp(const MyApp());
  });
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
            borderRadius: BorderRadius.circular(
                50.0), // floating action buttons are round
          ),
        ),
      ),
      navigatorObservers: [NavigationUtils.routeObserver],
      routes: {
        '/': (context) => const MyHomePage(),
        '/categories': (context) => const ChooseCategoriesPage(),
        '/current-players': (context) => const CurrentPlayersPage(),
        '/game-selection': (context) => const GameSelectionPage(),
        '/old-games-list': (context) => const OldGamesListSelectionPage(),
        '/game' : (context) => const MainGamePage(),
        '/game-bomb': (context) => const GameBombPage(),
        '/game-yesno': (context) => const GameYesNoPage(),
      },
    );
  }
}