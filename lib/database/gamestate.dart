import 'package:question_game/database/database_handler.dart';

/// Question class that holds the category id and the questionId
class Question {
  String categoryId;
  int questionId;
  String value;

  Question(this.categoryId, this.questionId, this.value);
}

/// holds the state of the game
class GameState {
  // Constructor
  GameState();

  // timestamp of when the game was played the last time
  int lastPlayed = 0;

  // list of player names
  List<String> players = [];

  // categoryId -> line numbers played in that category
  Map<String, List<int>> questionsPlayed = {
    for (var i = 0; i < DataBaseHandler().categoriesDescriptor.length; i++) i.toString(): []
  };

  // categories (ids) active
  List<String> categoriesActive = [];

  // the questions that will be played,
  // this is a list that contains the category id and the value of the question
  // as well as the questionId in the database
  // they will not be stored in the database (when toJson is being called)
  final questions = <Question>[];

  /// returns the next question to be played
  /// and handles the xy replacement
  Question? next() {
    if (questions.isEmpty) {
      return null;
    }

    // pop the first question from the list
    final question = questions.removeAt(0);

    // add the question id to the list of questions played
    questionsPlayed[question.categoryId]?.add(question.questionId);

    // xy replacement
    // xy is a placeholder for a player name
    // if there are more xy in the text than players,
    // skip the question
    if (question.value.split('xy').length - 1 > players.length) {
      return next();
    }

    // replace every xy in the question
    // with a (different and random) player name
    // to do so, shuffle the list of players,
    // then iterate over the question and replace every xy
    // with the next player name
    players.shuffle();

    int counter = 0;

    question.value = question.value.replaceAllMapped('xy', (match) {
      return players[counter++];
    });

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
