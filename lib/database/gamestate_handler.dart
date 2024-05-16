import 'dart:convert';

import 'package:question_game/database/gamestate.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// used to save and load the game states
class GameStateHandler {
  static var _currentGameState = GameState();

  static get currentGameState => _currentGameState;

  static GameState loadLatestGameState() {
    final savedGameStates = getSavedGameStates();
    if (savedGameStates.isNotEmpty) {
      _currentGameState = savedGameStates.last;
    }
    return _currentGameState;
  }

  static int getSavedGameStatesCount() {
    return BaseUtils.prefs?.getStringList('gameStates')?.length ?? 0;
  }

  static List<GameState> getSavedGameStates() {
    final gameStates = <GameState>[];
    final savedGameStatesAsStringList =
        BaseUtils.prefs?.getStringList('gameStates') ?? [];

    for (final gameStateString in savedGameStatesAsStringList) {
      gameStates.add(GameState.fromJson(jsonDecode(gameStateString)));
    }

    return gameStates;
  }
}
