import 'dart:convert';

import 'package:question_game/database/gamestate.dart';
import 'package:question_game/utils/base_utils.dart';

import 'database_handler.dart';

/// Class used to handle game states, including saving, loading, and playing games.
class GameStateHandler {
  /// The current game state.
  static GameState? currentGameState;

  /// Starts a new game with the active categories.
  static void playNewGame() {
    // Get the categories that are active from prefs
    // (they are saved in prefs with the keys 'category_N')
    List<String> categoriesActive = [];
    for (var categoryKey in DataBaseHandler.categoriesDescriptor.keys) {
      if (BaseUtils.prefs?.getBool('category_$categoryKey') ?? true) {
        categoriesActive.add(categoryKey);
      }
    }

    // Create a new game state with the active categories
    currentGameState = GameState(categoriesActive);
  }

  /// Loads the last (latest) played game state.
  static void playLastGame() {
    currentGameState = getSavedGameStates().firstOrNull;
  }

  /// Loads an old game state.
  static void playOldGame(GameState state) {
    currentGameState = state;
  }

  /// Saves the current game state to the shared preferences.
  /// If the game state has been played before, it replaces the old game state.
  static void save() {
    // If the current game state is null, do nothing
    if (currentGameState == null) {
      return;
    }

    // Add the current time stamp to the game state
    currentGameState!.lastPlayed = DateTime.now().millisecondsSinceEpoch;

    // Load all old game states
    final savedGameStates = getSavedGameStates();

    // Remove the old game state if it exists
    savedGameStates.removeWhere((element) => element.gameId == currentGameState!.gameId);
    // Add the current game state
    savedGameStates.add(currentGameState!);
    // Save the game states
    saveGameStateList(savedGameStates);
  }

  /// Saves the list of game states to the shared preferences.
  /// This overwrites the whole list.
  static void saveGameStateList(List<GameState> gameStates) {
    BaseUtils.prefs?.setStringList(
      'gameStates',
      gameStates.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  /// Returns the count of saved game states.
  static int getSavedGameStatesCount() {
    return BaseUtils.prefs?.getStringList('gameStates')?.length ?? 0;
  }

  /// Loads the game states from the shared preferences.
  /// Returns them sorted by the last played timestamp.
  static List<GameState> getSavedGameStates() {
    // Load the game states from the shared preferences
    final gameStates = <GameState>[];
    final savedGameStatesAsStringList =
        BaseUtils.prefs?.getStringList('gameStates') ?? [];

    // Convert each game state string to a GameState object
    for (final gameStateString in savedGameStatesAsStringList) {
      gameStates.add(GameState.fromJson(jsonDecode(gameStateString)));
    }

    // Sort by the last played timestamp
    gameStates.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));

    return gameStates;
  }
}