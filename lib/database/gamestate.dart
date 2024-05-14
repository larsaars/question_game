import 'dart:convert';

class GameState {
  // timestamp of when the game was played the last time
  int lastPlayed = 0;

  // list of player names
  List<String> players = [];

  // categoryId -> line numbers played in that category
  Map<String, List<int>> questionsPlayed = {
  };

  // categories active
  List<int> categoriesActive = [];

  // Convert GameState object to JSON
  Map<String, dynamic> toJson() {
    return {
      'lastPlayed': lastPlayed,
      'players': players,
      'questionsPlayed': questionsPlayed,
      'categoriesActive': categoriesActive,
    };
  }

  // Create GameState object from JSON
  GameState.fromJson(Map<String, dynamic> json)
      : lastPlayed = json['lastPlayed'],
        players = List<String>.from(json['players']),
        questionsPlayed = json['questionsPlayed'],
        categoriesActive = json['categoriesActive'];
}