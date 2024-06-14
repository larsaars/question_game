import 'package:question_game/database/database_handler.dart';
import 'package:uuid/uuid.dart';

/// Represents a question in the game.
class Question {
  /// The ID of the category this question belongs to.
  String categoryId;

  /// The unique ID of this question within its category.
  int questionId;

  /// The text of the question.
  String value;

  /// Constructor for the Question class.
  Question(this.categoryId, this.questionId, this.value);
}

/// Represents the state of the game.
class GameState {
  /// The unique ID of the game.
  String gameId = '';

  /// The timestamp of when the game was last played.
  int lastPlayed = 0;

  /// The list of player names.
  List<String> players = [];

  /// The list of questions that have been played, categorized by their category ID.
  Map<String, List<int>> questionsPlayed = {};

  /// The list of active categories (by ID).
  List<String> categoriesActive = [];

  /// The list of questions that will be played in this game.
  final questions = <Question>[];

  /// The current question being asked.
  Question? currentQuestion;

  /// Returns the next question to be played and handles the xy replacement.
  Question? next() {
    // If there are no more questions, return null
    if (questions.isEmpty) {
      return null;
    }

    // Remove the first question from the list and set it as the current question
    currentQuestion = questions.removeAt(0);

    // Add the question id to the list of questions played
    questionsPlayed[currentQuestion!.categoryId]?.add(currentQuestion!.questionId);

    // If the question is of category 4 (yes/no) and there are not at least 2 players, skip the question
    if (currentQuestion!.categoryId == '4' && players.length < 2) {
      return next();
    }

    // If there are more xy in the text than players, skip the question
    if (currentQuestion!.value.split('xy').length - 1 > players.length) {
      return next();
    }

    // Replace every xy in the question with a (different and random) player name
    players.shuffle();
    int counter = 0;
    currentQuestion!.value = currentQuestion!.value.replaceAllMapped('xy', (match) {
      return players[counter++];
    });

    return currentQuestion;
  }

  /// Returns the total number of questions that have been played.
  int getNumberOfPlayedQuestions() {
    int count = 0;
    for (var category in questionsPlayed.keys) {
      count += questionsPlayed[category]!.length;
    }
    return count;
  }

  /// Initializes a new game with the given active categories.
  GameState(this.categoriesActive) {
    // Create a new game with empty player name
    players.add('');
    // Generate a new game uuid
    gameId = const Uuid().v4();
    // Create an empty map for the questions played
    questionsPlayed = {
      for (var i = 0; i < DataBaseHandler.categoriesDescriptor.length; i++)
        i.toString(): []
    };
  }

  /// Converts the GameState object to a JSON representation.
  /// Note: the questions that have been loaded from the database will not be saved!
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'lastPlayed': lastPlayed,
      'players': players,
      'questionsPlayed': questionsPlayed,
      'categoriesActive': categoriesActive,
    };
  }

  /// Creates a GameState object from a JSON representation.
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