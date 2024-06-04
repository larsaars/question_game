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
  // if shows the loading circle (on prepareGameState)
  bool _loading = true;

  // app strings
  AppLocalizations? localizations;

  // title and body text of widgets
  String _titleText = '', _bodyText = '';

  // whether the current question needs a second tap
  // i.e. challenge category
  bool _needsSecondTap = false;

  // current question, if is null the page will be cancelled,
  // so will not be null
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
        setState(() => _nextQuestion());
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
    // if the current question still  needs a second tap,
    // don't directly load
    // next question method but handle the second tap
    // TODO this needs second tap part is done
    if (_needsSecondTap) {
      switch (currentQuestion!.categoryId) {
        case '1': // challenge
        case '2': // poll
          // for these categories, show the question on second tap
          _bodyText = currentQuestion!.value;
          break;
        case '3': // bomb
          // for bomb, show the bomb start button
          _bodyText = '';
          _showBombStartButton = true; // TODO show bomb button instead of body text
          break;
        case '0': // default question
        case '4': // yes or no
        default:
          // do nothing
          break;
      }
    } else {
      // get the next question
      currentQuestion = GameStateHandler.currentGameState!.next();
      // if there is no question, the game is over
      if (currentQuestion == null) {
        // pop the page, saving is done on dispose automatically
        Navigator.pop(context);
      } else {
        //  question is available, handle depending on the category id
        switch (currentQuestion!.categoryId) {
          case '0': // default question
            _needsSecondTap = false;
            _titleText = localizations!.gameDefaultRequestPlayerAction;
            _bodyText = currentQuestion!.value;
            break;
          case '1': // challenge
            _needsSecondTap = true;
            _titleText = ...
            _bodyText = ...
            break;
          case '2': // poll
            _needsSecondTap = true;
            _titleText = ...
            _bodyText = ...
            break;
          case '3': // bomb
            _needsSecondTap = true;
          _titleText = ...
          _bodyText = ...
            break;
          case '4': // yes or no
            _needsSecondTap = false;
            // TODO start yesno page
            break;
          default: // none?
            break;
        }
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
      onTap: () => setState(() => _nextQuestion()),
      // call tap screen and update the widget tree
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
                      _titleText,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'alte_haas_grotesk',
                        color: DataBaseHandler.categoriesDescriptor[
                            currentQuestion?.categoryId ?? '0']['color'],
                        fontSize: UIDefaults.gameRequestPlayerActionTextSize,
                      ),
                    ),
                    TextSwitcher(
                      _bodyText,
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
