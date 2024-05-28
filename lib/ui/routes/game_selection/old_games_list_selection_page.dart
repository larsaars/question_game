import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../database/gamestate.dart';

class OldGamesListSelectionPage extends StatefulWidget {
  const OldGamesListSelectionPage({super.key});

  @override
  State<OldGamesListSelectionPage> createState() =>
      _OldGamesListSelectionPageState();
}

class _OldGamesListSelectionPageState extends State<OldGamesListSelectionPage>
    with SingleTickerProviderStateMixin {
  late List<GameState> _gameStates;
  final _listKey = GlobalKey<AnimatedListState>();
  bool _gameStatesListChanged = false;

  @override
  void initState() {
    super.initState();
    // load old games from database
    // in order to display them in a listview
    _gameStates = GameStateHandler.getSavedGameStates();
  }

  @override
  void dispose() {
    // if  game states list was changed,
    // save the new list to the database
    if (_gameStatesListChanged) {
      GameStateHandler.saveGameStateList(_gameStates);
    }

    super.dispose();
  }

  String _beautifyPlayerList(List<String> players, [cutOver = 3]) {
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

  void _removeGameState(int index) {
    // remove from ram list, re-save list on dispose (if changed)
    setState(() {
      // mark the list as changed
      _gameStatesListChanged = true;
      // remove the game state from the list
      final removedGameState = _gameStates.removeAt(index);
      // remove from the animated list
      _listKey.currentState!.removeItem(
          index,
          (context, animation) =>
              _buildGameStateItem(removedGameState, animation, index));
    });
  }

  Widget _buildGameStateItem(
      GameState gameState, Animation<double> animation, int index) {

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: ListTile(
        title: Text(_beautifyPlayerList(gameState.players)),
        subtitle: Text(
          timeago.format(
            DateTime.fromMillisecondsSinceEpoch(gameState.lastPlayed),
            locale: AppLocalizations.of(context)!.localeName,
          ),
        ),
        onTap: () {
          // load the game state
          GameStateHandler.playOldGame(gameState);
          // navigate to the main game page
          Navigator.pushReplacementNamed(context, '/game');
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _removeGameState(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultScaffold(
      title: loc.oldGamesListSelectionPageTitle,
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _gameStates.length,
        itemBuilder: (context, index, animation) {
          return _buildGameStateItem(_gameStates[index], animation, index);
        },
      ),
    );
  }
}
