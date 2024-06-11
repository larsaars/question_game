import 'package:question_game/database/database_handler.dart';
import 'package:uuid/uuid.dart';

/// Question class that holds the category id and the questionId
class Question {
  String categoryId;
  int questionId;
  String value;

  Question(this.categoryId, this.questionId, this.value);
}

/// holds the state of the game
class GameState {
  // unique game id
  String gameId = '';

  // timestamp of when the game was played the last time
  int lastPlayed = 0;

  // list of player names
  List<String> players = [];

  // categoryId -> line numbers played in that category
  Map<String, List<int>> questionsPlayed = {};

  // categories (ids) active
  List<String> categoriesActive = [];

  // the questions that will be played,
  // this is a list that contains the category id and the value of the question
  // as well as the questionId in the database
  // they will not be stored in the database (when toJson is being called)
  final questions = <Question>[];

  // store current question as a variable so that it can be accessed from static currentGameState
  // will be set in next()
  Question? currentQuestion;

  /// returns the next question to be played
  /// and handles the xy replacement
  Question? next() {
    if (questions.isEmpty) {
      return null;
    }

    // pop the first question from the list
    currentQuestion = questions.removeAt(0);

    // add the question id to the list of questions played
    questionsPlayed[currentQuestion!.categoryId]?.add(currentQuestion!.questionId);

    // if the question is of category 4 (yes/no)
    // and there are not at least 2 players,
    // skip the question
    if (currentQuestion!.categoryId == '4' && players.length < 2) {
      return next();
    }

    // xy replacement
    // xy is a placeholder for a player name
    // if there are more xy in the text than players,
    // skip the question
    if (currentQuestion!.value.split('xy').length - 1 > players.length) {
      return next();
    }

    // replace every xy in the question
    // with a (different and random) player name
    // to do so, shuffle the list of players,
    // then iterate over the question and replace every xy
    // with the next player name
    players.shuffle();

    int counter = 0;

    currentQuestion!.value = currentQuestion!.value.replaceAllMapped('xy', (match) {
      return players[counter++];
    });

    return currentQuestion;
  }

  int getNumberOfPlayedQuestions() {
    int count = 0;
    for (var category in questionsPlayed.keys) {
      count += questionsPlayed[category]!.length;
    }
    return count;
  }

  // init as new game
  GameState(this.categoriesActive) {
    // create a new game with empty player name
    players.add('');
    // and a new game uuid
    gameId = const Uuid().v4();
    // create an empty map for the questions played
    questionsPlayed = {
      for (var i = 0; i < DataBaseHandler.categoriesDescriptor.length; i++)
        i.toString(): []
    };
  }

  // Convert GameState object to JSON
  // note: the questions that have been loaded
  // from the database will not be saved!
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'lastPlayed': lastPlayed,
      'players': players,
      'questionsPlayed': questionsPlayed,
      'categoriesActive': categoriesActive,
    };
  }

  // Create GameState object from JSON
  GameState.fromJson(Map<String, dynamic> json)
      : gameId = json['gameId'],
        lastPlayed = json['lastPlayed'],
        players = List<String>.from(json['players']),
        categoriesActive = List<String>.from(json['categoriesActive']) {
    // Manually parse the questionsPlayed map
    questionsPlayed = Map<String, List<int>>.from(
      json['questionsPlayed'].map(
        (key, value) => MapEntry(key, List<int>.from(value.cast<int>())),
      ),
    );
  }
}
