
import 'package:question_game/database/gamestate.dart';

class GameStateHandler {
  static final GameStateHandler _singleton = GameStateHandler._internal();

  factory GameStateHandler() {
    return _singleton;
  }

  GameStateHandler._internal();

  GameState _currentGameState = GameState();

  GameState get currentGameState => _currentGameState;

  void saveGameState(GameState gameState) {
    _currentGameState = gameState;
  }

  GameState loadLatestGameState() {
    return GameState();
  }

  int getSavedGameStatesCount() {
    return 0;
  }

  List<GameState> getSavedGameStates() {
    return [];
  }
}