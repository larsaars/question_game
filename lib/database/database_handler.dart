import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:question_game/database/gamestate.dart';

class DataBaseHandler {
  static final DataBaseHandler _instance = DataBaseHandler();

  factory DataBaseHandler() {
    return _instance;
  }

  static int NUMBER_OF_CATEGORIES = 6;

  // todo has to be loaded on app start
  static Map<String, dynamic> categoriesDescriptor = {};

  static Future<Map<String, dynamic>> loadCategoriesDescriptor() async {
    String jsonString = await rootBundle
        .loadString('question_database/categories_descriptor.json');
    return jsonDecode(jsonString);
  }

  //TODO does this belong in here or in game state handler?
  // TODO since there are multiple files per category, using only line numbers has to be changed, we have overlaps
  /// loads the questions from the database that are to be played
  static Future<GameState> prepareGameState(GameState state) async {
    // load only the categories that are active
    // as well as only the questions that have not been played yet
    // and shuffle them

    // load from database the txt files of categories active
    for (var category in state.categoriesActive) {
      // questions of the category
      List<Question> categoriesQuestions = [];
      // load all categories questions' files
      for (var file in categoriesDescriptor[category]['files']) {
        // load the file
        final content =
            await rootBundle.loadString('question_database/$file');
        // each line is a question
        final lines = content.split('\n');
        // loop through the lines in order to assign
        // questionIds (line numbers)
        for (int i = 0; i < lines.length; i++) {
          categoriesQuestions.add(Question(category, i, lines[i]));
        }
      }

      // now remove all questions that have been played
    }

    return state;
  }
}
