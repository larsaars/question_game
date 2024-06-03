import 'dart:convert';

import 'package:question_game/database/gamestate.dart';
import 'package:question_game/utils/base_utils.dart';

import 'database_handler.dart';

/// used to save and load the game states
class GameStateHandler {
  static GameState? currentGameState;

  static void playNewGame() {
    // get the categories that are active from prefs
    // (they are saved in prefs with the keys 'category_N')
    List<String> categoriesActive = [];
    for (var categoryKey in DataBaseHandler.categoriesDescriptor.keys) {
      if (BaseUtils.prefs?.getBool('category_$categoryKey') ?? true) {
        categoriesActive.add(categoryKey);
      }
    }

    currentGameState = GameState(categoriesActive);
  }

  static void playLastGame() {
    // load the last (latest) played game state
    currentGameState = getSavedGameStates().firstOrNull;
  }

  static void playOldGame(GameState state) {
    currentGameState = state;
  }

  /// save the current game state
  /// to the shared preferences
  /// and make sure to replace the old game state (uuid)
  /// if it has been played before
  static void save() {
    // if the current game state is null, do nothing
    if (currentGameState == null) {
      return;
    }

    // add the current time stamp to the game state
    currentGameState!.lastPlayed = DateTime.now().millisecondsSinceEpoch;

    // load all old game states
    final savedGameStates = getSavedGameStates();

    // remove the old game state if it exists
    savedGameStates.removeWhere((element) => element.gameId == currentGameState!.gameId);
    // add the current game state
    savedGameStates.add(currentGameState!);
    // save the game states
    saveGameStateList(savedGameStates);
  }

  /// save the game states to the shared preferences
  /// overwrites whole list
  static void saveGameStateList(List<GameState> gameStates) {
    BaseUtils.prefs?.setStringList(
      'gameStates',
      gameStates.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static int getSavedGameStatesCount() {
    return BaseUtils.prefs?.getStringList('gameStates')?.length ?? 0;
  }

  /// loads the game states from the shared preferences
  /// and returns them sorted by the last played timestamp
  static List<GameState> getSavedGameStates() {
    // load the game states from the shared preferences
    final gameStates = <GameState>[];
    final savedGameStatesAsStringList =
        BaseUtils.prefs?.getStringList('gameStates') ?? [];

    for (final gameStateString in savedGameStatesAsStringList) {
      gameStates.add(GameState.fromJson(jsonDecode(gameStateString)));
    }

    // sort by the last played timestamp
    gameStates.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));

    return gameStates;
  }
}
