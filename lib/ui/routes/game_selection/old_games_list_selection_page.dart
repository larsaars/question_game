import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class OldGamesListSelectionPage extends StatelessWidget {
  const OldGamesListSelectionPage({super.key});

  String _beautifyPlayerList(List<String> players, [cutOver=3]) {
    // load string of players as title
    // last divisor is not a comma but a "&"
    // and limit the number of names displayed
    final len = players.length;

    if (len == 0) {
      return '';
    }

    var beautified = players[0];

    for (var i = 1; i < len; i++) {
      if (i > cutOver) {
        break;
      }

      if (i == cutOver || i == len - 1) {
        beautified += ' & ${players[i]}';
      } else {
        beautified += ', ${players[i]}';
      }
    }

    return beautified;
  }

  @override
  Widget build(BuildContext context) {
    // init loc
    final loc = AppLocalizations.of(context)!;

    // load old games from database
    // and display them in a list
    final gameStates = GameStateHandler.getSavedGameStates();

    // TODO add delete games option as icon on right
    return DefaultScaffold(
      title: loc.oldGamesListSelectionPageTitle,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: gameStates.length,
          itemBuilder: (BuildContext context, int index) {
            final gameState = gameStates[index];
            return ListTile(
              title: Text(_beautifyPlayerList(gameState.players)),
              subtitle: Text(
                timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(gameState.lastPlayed),
                  locale: loc.localeName,
                ),
              ),
              onTap: () {
                // load the game state
                GameStateHandler.playOldGame(gameState);
                // navigate to the main game page
                Navigator.pushReplacementNamed(context, '/game');
              },
            );
          }),
    );
  }
}
