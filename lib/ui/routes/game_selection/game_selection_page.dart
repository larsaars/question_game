import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/widgets/centered_text_icon_button.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/navigation_utils.dart';

import '../../ui_defaults.dart';

class GameSelectionPage extends StatelessWidget {
  const GameSelectionPage({super.key});

  @override
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
              CenteredTextIconButton(
                icon: Icons.fiber_new,
                text: localizations!.gameSelectionPageNewGame,
                textColor: UIDefaults.colorPrimary,
                iconColor: UIDefaults.colorPrimary,
                onPressed: () {
                  // load new game state and then navigate to
                  // enter the player names
                  GameStateHandler.playNewGame();
                  Navigator.pushNamed(context, '/current-players',
                      arguments: {'comingFrom': 'game-selection'});
                },
              ),
              CenteredTextIconButton(
                icon: Icons.last_page,
                text: DefaultScaffold.usesPadding
                    ? localizations.gameSelectionPageContinueLastGameWithPadding
                    : localizations
                        .gameSelectionPageContinueLastGameWithoutPadding,
                onPressed: () {
                  // load last game state and then navigate to game
                  GameStateHandler.playLastGame();
                  NavigationUtils.pushNamedAndPopTillMain(context, '/game');
                },
              ),
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
