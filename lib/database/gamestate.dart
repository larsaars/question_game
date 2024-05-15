import 'dart:convert';

import 'package:question_game/database/database_handler.dart';

/// Question class that holds the category id and the line number of the question
class Question {
  String categoryId;
  int questionLineNumber;
  String value;

  Question(this.categoryId, this.questionLineNumber, this.value);
}

class GameState {
  // Constructor
  GameState();

  // timestamp of when the game was played the last time
  int lastPlayed = 0;

  // list of player names
  List<String> players = [];

  // categoryId -> line numbers played in that category
  Map<String, List<int>> questionsPlayed = {
    for (var i = 0; i < DataBaseHandler.NUMBER_OF_CATEGORIES; i++) i.toString(): []
  };

  // categories (ids) active
  List<String> categoriesActive = [];

  // the questions that will be played,
  // this is a list that contains the category id and the value of the question
  // as well as the line number of the question in the database
  // they will not be stored in the database (when toJson is being called)
  final questions = <Question>[];

  /// returns the next question to be played
  Question? next() {
    if (questions.isEmpty) {
      return null;
    }

    // pop the first question from the list
    final question = questions.removeAt(0);

    // add the question id to the list of questions played
    questionsPlayed[question.categoryId]?.add(question.questionLineNumber);

    return question;
  }

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
