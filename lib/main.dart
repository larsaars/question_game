import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/ui_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question Game',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
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
        backgroundColor: createRandomPastelBackgroundColor(),
        body: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'image/app_icon.png',
                          height: 100,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: SizedBox(
                    height: 48,
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.videogame_asset,
                            size: 42,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.startGame,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
