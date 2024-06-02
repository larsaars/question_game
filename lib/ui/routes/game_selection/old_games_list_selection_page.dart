import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/navigation_utils.dart';
import 'package:question_game/utils/ui_utils.dart';
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
  AppLocalizations? localizations;

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
        title: Text(
          UIUtils.beautifyStringListForDisplaying(
            gameState.players,
            moreWord: localizations!.oldGamesListSelectionPageMorePlayers,
          ),
        ),
        subtitle: Text(
          '${timeago.format(
            DateTime.fromMillisecondsSinceEpoch(gameState.lastPlayed),
            locale: localizations!.localeName,
          )}: ${gameState.questions.length} ${localizations!.oldGamesListSelectionPageQuestionsPlayed}',
        ),
        onTap: () {
          // load the game state
          GameStateHandler.playOldGame(gameState);
          // navigate to the main game page
          NavigationUtils.pushNamedAndPopTillMain(context, '/game');
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
    localizations ??= AppLocalizations.of(context)!;

    return DefaultScaffold(
      title: localizations!.oldGamesListSelectionPageTitle,
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
