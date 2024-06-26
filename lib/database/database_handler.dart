import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:question_game/database/gamestate.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/utils/ui_utils.dart';

/// Class that handles the database
/// Note: this approach is not very efficient, since we load the whole database
/// every time we want to play a game
/// this works under the assumption that the database is quite small
/// but since it is "only" text based, it should be fine ( < 1MB)
class DataBaseHandler {
  // invoked on app start
  static Map<String, dynamic> categoriesDescriptor = {};

  /// Loads the categories descriptor JSON file and replaces string colors to actual color objects.
  static Future loadCategoriesDescriptor() async {
    // load the categories descriptor json file
    String jsonString = await rootBundle
        .loadString('question_database/categories_descriptor.json');
    categoriesDescriptor = jsonDecode(jsonString);

    // replace string colors to actual color objects
    for (final category in categoriesDescriptor.keys) {
      categoriesDescriptor[category]['color'] =
          UIUtils.hexToColor(categoriesDescriptor[category]['color']);
    }
  }

  /// Prepares the game state by loading only the active categories and the questions that have not been played yet.
  /// Then shuffles all questions and adds them to the game state.
  static Future prepareGameState() async {
    // if the current game state is null, do nothing
    if (GameStateHandler.currentGameState == null) {
      return;
    }

    // get the current game state
    final state = GameStateHandler.currentGameState!;

    // load from database the txt files of active categories
    for (var category in state.categoriesActive) {
      // questions of the category
      List<Question> categoriesQuestions = [];
      // since there might be multiple files per category,
      // using only the line number of each question is not unique
      // for the category
      // hence we build a questionId that is unique for each question
      // by using a counter
      // so in the end, we have for different categories overlapping question ids,
      // but for the same category, the question ids are unique
      // NOTE: this also means though, that a saved game state becomes invalid
      // when the database changes by only one line,
      // since the question ids are not the same anymore
      int questionId = 0;
      // load all categories questions' files
      for (final file in categoriesDescriptor[category]['files']) {
        // load the file
        final content = await rootBundle.loadString('question_database/$file');
        // each line is a question
        for (final line in content.split('\n')) {
          // skip empty lines or lines that start with
          // a '#' (comment)
          if (line.isEmpty || line.startsWith('#')) {
            continue;
          }

          // keep a continuous question id and add the question to the list
          categoriesQuestions.add(Question(category, questionId++, line));
        }
      }

      // now remove all questions that have been played already
      // from the list
      for (final question in state.questionsPlayed[category]!) {
        categoriesQuestions
            .removeWhere((element) => element.questionId == question);
      }

      // now, finally add the questions to the game state
      state.questions.addAll(categoriesQuestions);
    }

    // shuffle the questions
    state.questions.shuffle();
  }
}