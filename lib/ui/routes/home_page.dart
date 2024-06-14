import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database_handler.dart';
import '../widgets/centered_text_icon_button.dart';
import '../widgets/default_scaffold.dart';

/// The home page of the application.
/// It extends [StatefulWidget] which means it maintains state that can change over time.
class MyHomePage extends StatefulWidget {
  // Constructor
  const MyHomePage({super.key});

  // Creates the mutable state for this widget at a given location in the tree.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// The logic and internal state for a [MyHomePage] widget.
class _MyHomePageState extends State<MyHomePage> {
  // App strings
  AppLocalizations? localizations;

  late Timer _timer;
  String _titleText = '';
  String? _defaultTitleText;

  bool _withBang = false;

  bool _loading = true;

  // Called when this object is inserted into the tree.
  @override
  void initState() {
    super.initState();

    // Load on start everything that has to be loaded
    _onStartLoading().then(
      (value) => setState(() {
        _loading = false;

        // After that,
        // create a timer that changes the text every n seconds
        // for the title to blink with a "!" at the end
        _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
          setState(() {
            // Update text field
            _withBang = !_withBang;

            if (_withBang) {
              _titleText = '$_defaultTitleText!';
            } else {
              _titleText = _defaultTitleText ?? '';
            }
          });
        });
      }),
    );
  }

  // Called when this object is removed from the tree permanently.
  @override
  void dispose() {
    super.dispose();
    // Cancel timer when the widget is disposed
    _timer.cancel();
  }

  // Load the categories descriptor on app start
  // as well once an instance of shared prefs
  Future _onStartLoading() async {
    await DataBaseHandler.loadCategoriesDescriptor();
    BaseUtils.prefs = await SharedPreferences.getInstance();
  }

  // Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    localizations ??= AppLocalizations.of(context);

    // Default title text can only be here set (not in initState)
    // since it requires the context which is not available before
    _defaultTitleText ??= _titleText = localizations!.appTitle;

    return DefaultScaffold(
      backButton: false,
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _titleText,
                        style: const TextStyle(
                          fontSize: 64,
                          fontFamily: 'alte_haas_grotesk',
                          fontWeight: FontWeight.w700,
                          color: UIDefaults.colorPrimary,
                        ),
                      ),
                    ),
                    CenteredTextIconButton(
                      icon: Icons.videogame_asset,
                      text: localizations!.mainPageStartGame,
                      textColor: UIDefaults.colorPrimary,
                      iconColor: UIDefaults.colorPrimary,
                      onPressed: () {
                        // If there are no saved game states, start a new game
                        if (GameStateHandler.getSavedGameStatesCount() == 0) {
                          GameStateHandler.playNewGame();
                          Navigator.pushNamed(context, '/current-players',
                              arguments: {'comingFrom': 'home-page'});
                        } else {
                          // Else go into game selection
                          Navigator.pushNamed(context, '/game-selection');
                        }
                      },
                    ),
                    CenteredTextIconButton(
                      icon: Icons.category,
                      text: DefaultScaffold.usesPadding
                          ? localizations!.mainPageChooseCategoriesWithPadding
                          : localizations!
                              .mainPageChooseCategoriesWithoutPadding,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/categories'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}