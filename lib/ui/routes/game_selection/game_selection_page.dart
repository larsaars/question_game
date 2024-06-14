import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/widgets/centered_text_icon_button.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/navigation_utils.dart';

import '../../ui_defaults.dart';

/// [GameSelectionPage] is a stateless widget that represents the game selection page.
/// It provides options to start a new game, continue the last game, or choose an old game.
class GameSelectionPage extends StatelessWidget {
  const GameSelectionPage({super.key});

  @override
  /// Builds the widget tree for the game selection page.
  ///
  /// The page contains three buttons:
  /// - A button to start a new game.
  /// - A button to continue the last game.
  /// - A button to choose an old game (only visible if there is more than one saved game state).
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    bool hasMoreThanOneSavedGameStates =
        GameStateHandler.getSavedGameStatesCount() > 1;

    return DefaultScaffold(
      child: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Button to start a new game.
              CenteredTextIconButton(
                icon: Icons.fiber_new,
                text: localizations!.gameSelectionPageNewGame,
                textColor: UIDefaults.colorPrimary,
                iconColor: UIDefaults.colorPrimary,
                onPressed: () {
                  // Load new game state and then navigate to
                  // enter the player names.
                  GameStateHandler.playNewGame();
                  Navigator.pushNamed(context, '/current-players',
                      arguments: {'comingFrom': 'game-selection'});
                },
              ),
              // Button to continue the last game.
              CenteredTextIconButton(
                icon: Icons.last_page,
                text: DefaultScaffold.usesPadding
                    ? localizations.gameSelectionPageContinueLastGameWithPadding
                    : localizations
                        .gameSelectionPageContinueLastGameWithoutPadding,
                onPressed: () {
                  // Load last game state and then navigate to game.
                  GameStateHandler.playLastGame();
                  NavigationUtils.pushNamedAndPopTillMain(context, '/game');
                },
              ),
              // Button to choose an old game (only visible if there is more than one saved game state).
              if (hasMoreThanOneSavedGameStates)
                CenteredTextIconButton(
                  icon: Icons.list,
                  text: localizations.gameSelectionPageChooseOldGame,
                  onPressed: () =>
                      Navigator.pushNamed(context, '/old-games-list'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}