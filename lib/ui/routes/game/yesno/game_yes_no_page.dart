import 'package:flutter/material.dart';
import 'package:question_game/ui/routes/game/yesno/yes_no_submit_answer_dialog_widget.dart';
import 'package:question_game/ui/routes/game/yesno/yesno_answer.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:question_game/ui/widgets/my_animated_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../database/database_handler.dart';
import '../../../../database/gamestate_handler.dart';
import '../../../../utils/navigation_utils.dart';
import '../../../../utils/ui_utils.dart';
import '../../../ui_defaults.dart';

class GameYesNoPage extends StatefulWidget {
  const GameYesNoPage({super.key});

  @override
  State<GameYesNoPage> createState() => _GameYesNoPageState();
}

class _GameYesNoPageState extends State<GameYesNoPage> {
  // app strings
  AppLocalizations? localizations;

  // the defining color of this game category
  final _yesnoColor = DataBaseHandler.categoriesDescriptor['4']['color'];

  // body and title text
  String _titleText = '', _bodyText = '';

  // there are 6 screens in this category (0-5)
  int _currentScreen = 0;

  // map of players: their answers and guesses
  final Map<String, YesNoAnswer> _answers = {};

  @override
  void initState() {
    super.initState();

    // pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      NavigationUtils.popWhenPossible(context);
    }

    // init map of players and their answers and guesses
    GameStateHandler.currentGameState?.players.forEach((player) {
      _answers[player] = YesNoAnswer();
    });
  }

  void _onTap({updateCounter = true}) {
    // if is on screen 3, do nothing on tap
    // (screen 3 will be handled by list of players and their answers and guesses)
    if (_currentScreen == 3) return;

    // update screen counter
    if (updateCounter) {
      _currentScreen++;
    }

    // update body text depending on screen
    switch (_currentScreen) {
      // screen 0: show first explanation
      case 1: // screen 1: first explanation was shown, now show the statement
        // the statement is the value of the current question
        _bodyText =
            GameStateHandler.currentGameState?.currentQuestion?.value ?? '';
        break;
      case 2: // screen 2: show next explanation
        _bodyText = localizations!.gameYesNoExplanation2;
        break;
      // screen 3: show list of players and let them enter their answer (yes or no) and guess
      case 4: // screen 4: show next explanation
        _bodyText = localizations!.gameYesNoAnswersReady;
        break;
      case 5: // screen 5: show results (how many yes and who gets how many points)
        // get number of yes answers
        final yesAnswers =
            _answers.values.where((element) => element.answer).length;
        // set title text to number of yes answers
        _titleText = yesAnswers.toString();
        // set body text how many points each player gets
        // you get:
        // - 3 points for a correct guess
        // - 1 point for a guess that's +1 or -1 off the correct answer
        // - else nothing
        // lists for players with correct guess, guess +1 or -1 off
        List<String> correctGuesses = [], guessOneOff = [];
        for (final player in _answers.keys) {
          final answer = _answers[player]!;
          if (yesAnswers == answer.guess) {
            correctGuesses.add(player);
          } else if (yesAnswers - 1 == answer.guess ||
              yesAnswers + 1 == answer.guess) {
            guessOneOff.add(player);
          }
        }

        // show beautified list of players with correct guess and guess +1 or -1 off
        _bodyText = '${localizations!.gameYesNoPlayerAnsweredYes(yesAnswers)}\n';
        if (correctGuesses.isNotEmpty) {
          _bodyText += '\n';
          _bodyText += localizations!.gameYesNoPlayerGuessedCorrectly(
            correctGuesses.length,
            UIUtils.beautifyStringListForDisplaying(correctGuesses, limitOfShownStrings: 6),
          );
        }

        if (guessOneOff.isNotEmpty) {
          _bodyText += '\n';
          _bodyText += localizations!.gameYesNoPlayerGuessedOneOff(
            guessOneOff.length,
            UIUtils.beautifyStringListForDisplaying(guessOneOff, limitOfShownStrings: 6),
          );
        }
        break;
      case 6: // screen 6: exit
        Navigator.pop(context);
        break;
    }
  }

  /// shows the dialog in which the answer and guess will be submitted
  void _showAnsweringDialog(String player) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return YesNoSubmitAnswerDialogWidget(
              setState: setState,
              answer: _answers[player]!,
              yesNoColor: _yesnoColor,
            );
          },
        );
      },
    ).then((_) {
      // if the dialog was closed, check if all players have answered
      if (_answers.values.every((element) => element.hasAnswered)) {
        // if all players have answered, show the results
        // update screen number here
        _currentScreen = 4;
        setState(() => _onTap(updateCounter: false));
      } else {
        // set state either way since the icon has to be updated
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (localizations == null) {
      // if localizations is null, set it
      localizations = AppLocalizations.of(context);
      // and load first screens body and title text
      _titleText = localizations!.gameTitleTextYesNo;
      _bodyText = localizations!.gameYesNoExplanation1;
    }

    return GestureDetector(
      onTap: () => setState(_onTap),
      child: DefaultScaffold(
        backButtonIcon: Icons.close,
        backButtonFunction: () => NavigationUtils.fromGamePopTillMain(context),
        backButtonTooltip: localizations!.gameExit,
        topRightWidget: IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_right),
          tooltip: localizations!.gameSkip,
          onPressed: () => Navigator.pop(context),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // title text is only needed on first and last screen
              if (_currentScreen == 0 || _currentScreen == 5)
                Text(
                  _titleText,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'alte_haas_grotesk',
                    color: _yesnoColor,
                    fontSize: UIDefaults.gameTitleTextSize,
                  ),
                ),
              if (_currentScreen == 3)
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _answers.length,
                      itemBuilder: (context, index) {
                        final player = _answers.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () => _showAnsweringDialog(player),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      player,
                                      style: TextStyle(
                                        fontSize: UIDefaults.gameBodyTextSize,
                                        color: _yesnoColor,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      _answers[player]!.hasAnswered
                                          ? Icons.check
                                          : Icons.subdirectory_arrow_left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (_currentScreen != 3)
                MyAnimatedSwitcher(
                  child: UIUtils.htmlToTextWidget(
                    _bodyText,
                    key: ValueKey<String>(_bodyText),
                    textAlign: TextAlign.center,
                    style: UIDefaults.gameBodyTextStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
