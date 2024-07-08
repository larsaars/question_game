import 'package:flutter/material.dart';
import 'package:question_game/database/database_handler.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:question_game/utils/navigation_utils.dart';
import 'package:question_game/utils/ui_utils.dart';

import '../../../database/gamestate.dart';
import '../../widgets/my_animated_switcher.dart';

/// MainGamePage is a StatefulWidget that represents the main game page.
/// It manages the game state and handles the game logic.
class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

/// _MainGamePageState is the state for MainGamePage.
/// It handles the game logic and updates the UI based on the game state.
class _MainGamePageState extends State<MainGamePage> with RouteAware {
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

  // whether to show the bomb start button
  bool _showStartBombButton = false;

  @override
  void initState() {
    super.initState();

    // pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      NavigationUtils.popWhenPossible(context);
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // subscribe to the route observer (for didPopNext)
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        NavigationUtils.routeObserver.subscribe(this, route);
      }
    });
  }

  @override
  void dispose() {
    // save here the current game state
    GameStateHandler.save();

    // unsubscribe from the route observer
    NavigationUtils.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPopNext() {
    // load next question when the page is shown again
    // (popped/returning from bomb or yesno pages)

    // if the user wants to pop till main, do not load the next question
    // (which could lead to unexpected behaviour such as routing to the next yesno page)
    if (NavigationUtils.wantsToPopTillMain) {
      // reset flag
      NavigationUtils.wantsToPopTillMain = false;
    } else {
      setState(_nextQuestion);
    }
  }

  /// _nextQuestion handles the logic for loading the next question.
  /// It checks the category of the current question and updates the UI accordingly.
  void _nextQuestion() {
    // if the current question still  needs a second tap,
    // don't directly load
    // next question method but handle the second tap
    if (_needsSecondTap) {
      // reset bool
      _needsSecondTap = false;

      switch (currentQuestion!.categoryId) {
        case '1': // challenge
        case '2': // poll
          // for these categories, show the question on second tap
          _bodyText = currentQuestion!.value;
          break;
        case '3': // bomb
          // for bomb, show the bomb start button
          _bodyText = '';
          _showStartBombButton = true;
          break;
        case '0': // default question
        case '4': // yes or no
        default:
          // do nothing
          break;
      }
    } else {
      // the show bomb button will be hidden in any case
      _showStartBombButton = false;
      // get the next question
      currentQuestion = GameStateHandler.currentGameState!.next();
      // if there is no question, the game is over
      if (currentQuestion == null) {
        // show a message why popping
        UIUtils.showToast(localizations!.gameNoQuestionsLeft);
        // pop the page, saving is done on dispose automatically
        NavigationUtils.popWhenPossible(context);
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
            _titleText = localizations!.gameTitleTextChallenge;
            _bodyText = localizations!.gameBodyTextChallenge(BaseUtils.random.nextInt(4) + 1); // number of random sips
            break;
          case '2': // poll
            _needsSecondTap = true;
            _titleText = localizations!.gameTitleTextPoll;
            _bodyText = localizations!.gameBodyTextPoll;
            break;
          case '3': // bomb
            _needsSecondTap = true;
            _titleText = localizations!.gameTitleTextBomb;
            _bodyText = localizations!.gameBodyTextBomb(BaseUtils.random.nextInt(4) + 1); // number of random sips
            break;
          case '4': // yes or no
            _needsSecondTap = false;
            NavigationUtils.pushNamedWhenPossible(context, '/game-yesno');
            break;
          default: // none?
            break;
        }
      }
    }
  }

  /// _editPlayerList navigates to the current players page.
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
      onTap: () => setState(_nextQuestion),
      // call tap screen and update the widget tree
      child: DefaultScaffold(
        backButtonIcon: Icons.close,
        backButtonTooltip: localizations!.gameExit,
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
                    MyAnimatedSwitcher(
                      child: Text(
                        _titleText,
                        key: ValueKey<String>(_titleText),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'alte_haas_grotesk',
                          color: DataBaseHandler.categoriesDescriptor[
                              currentQuestion?.categoryId ?? '0']['color'],
                          fontSize: UIDefaults.gameTitleTextSize,
                        ),
                      ),
                    ),
                    MyAnimatedSwitcher(
                      child: _showStartBombButton
                          ? ElevatedButton(
                              onPressed: () =>
                                  NavigationUtils.pushNamedWhenPossible(
                                      context, '/game-bomb'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    localizations!.gameStartBombButton,
                                    style: UIDefaults.gameBodyTextStyle,
                                  ),
                                ],
                              ),
                            )
                          : Text(
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