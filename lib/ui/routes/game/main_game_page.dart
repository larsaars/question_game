import 'package:flutter/material.dart';
import 'package:question_game/database/database_handler.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/widgets/text_switcher.dart';

import '../../../database/gamestate.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  bool _loading = true;

  AppLocalizations? localizations;
  String titleText = 'whatever';
  Question? currentQuestion;

  @override
  void initState() {
    super.initState();

    // pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    // prepare the game state (load the questions from database)
    // and then set the loading to false
    DataBaseHandler.prepareGameState().then((_) {
      setState(() {
        // load the first question to show
        _nextQuestion();
        // set loading circle to disappear
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    // save here the current game state
    GameStateHandler.save();

    super.dispose();
  }

  // TODO: explanation texts for the different categories
  // on second tap show the question
  // integrate into app_de.arb
  // add bomb and yes/no pages though
  void _nextQuestion() {
    // get the next question
    currentQuestion = GameStateHandler.currentGameState?.next();
    // if there is no question, the game is over
    if (currentQuestion == null) {
      // pop the page, saving is done on dispose automatically
      Navigator.pop(context);
    } else {
      //  question is available, handle depending on the category id
      switch (currentQuestion!.categoryId) {
        case '1': // default question
          titleText = localizations!.gameDefaultRequestPlayerAction;
          break;
        case '2': // challenge
        titleText = 'Challenge!';
          break;
        case '3': // poll
        titleText = 'Poll!';
          break;
        case '4': // bomb
        titleText = 'Bomb!';
          break;
        case '5': // yes or no
        titleText = 'Yes or No!';
          break;
        case '6': // rule
        titleText = 'Rule!';
          break;
        default: // none?
          break;
      }
    }
  }

  void _editPlayerList() {
    // navigate to the current players page
    // and declare that it is coming from the main game
    // (this is important for navigation)
    Navigator.pushNamed(context, '/current-players', arguments: {
      'comingFrom': 'main-game',
    });
  }

  @override
  Widget build(BuildContext context) {
    localizations ??= AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => setState(() => _nextQuestion()), // next question on tap and update view
      child: DefaultScaffold(
        topRightWidget: IconButton(
          icon: const Icon(Icons.edit_note),
          onPressed: _editPlayerList,
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextSwitcher(
                      titleText,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'alte_haas_grotesk',
                        color: DataBaseHandler.categoriesDescriptor[
                            currentQuestion?.categoryId ?? '0']['color'],
                        fontSize: UIDefaults.gameRequestPlayerActionTextSize,
                      ),
                    ),
                    TextSwitcher(
                      currentQuestion?.value ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
