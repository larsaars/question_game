import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:timeago/timeago.dart' as timeago;

class OldGamesListSelectionPage extends StatelessWidget {
  const OldGamesListSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // load old games from database
    // and display them in a list
    final gameStates = GameStateHandler.getSavedGameStates();

    // TODO format names and titles etc
    return DefaultScaffold(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: gameStates.length,
          itemBuilder: (BuildContext context, int index) {
            final gameState = gameStates[index];
            return ListTile(
              title: Text(timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(gameState.lastPlayed))),
              subtitle: Text('Game ID: ${gameState.gameId}'),
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
