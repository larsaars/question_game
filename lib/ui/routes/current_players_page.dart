import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/navigation_utils.dart';

import '../../utils/ui_utils.dart';
import '../widgets/default_scaffold.dart';

/// This class represents the Current Players Page in the application.
/// It extends StatefulWidget, which means this widget can change over time.
class CurrentPlayersPage extends StatefulWidget {
  const CurrentPlayersPage({super.key});

  @override
  State<CurrentPlayersPage> createState() => _CurrentPlayersPageState();
}

/// This class represents the state of the Current Players Page.
/// It extends State<CurrentPlayersPage> and includes SingleTickerProviderStateMixin for animation control.
class _CurrentPlayersPageState extends State<CurrentPlayersPage>
    with SingleTickerProviderStateMixin {
  final _listKey = GlobalKey<AnimatedListState>();
  final _scrollController = ScrollController();
  List<FocusNode> _focusNodes = [];
  late String _comingFromRoute;

  late List<String> _currentPlayers;

  @override
  void initState() {
    super.initState();

    // if the current game state is null, pop the page
    if (GameStateHandler.currentGameState == null) {
      NavigationUtils.popWhenPossible(context);
    }

    // set preferred orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // pass the reference of the list to the state
    _currentPlayers = GameStateHandler.currentGameState?.players ?? [];

    // create a focus node for each player
    _focusNodes = List.generate(_currentPlayers.length, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // focus first text field after build
      FocusScope.of(context).requestFocus(_focusNodes.first);
      // when the page is built, we always pass an argument where we come from
      // this is important for the navigation
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _comingFromRoute = args['comingFrom'];
    });
  }

  /// This method builds a player item widget.
  /// It takes a player name, an animation, and an index as parameters.
  Widget _buildPlayerItem(
      String player, Animation<double> animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: ListTile(
        title: TextField(
          controller: TextEditingController(text: player),
          focusNode: _focusNodes[index],
          enabled: true,
          decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context)!.currentPlayersPagePlayerName,
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            // on submit, shift focus to the next text field
            // or if it's the last one, add a new player
            if (index < _currentPlayers.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              _addPlayer();
            }
          },
          onChanged: (value) {
            _currentPlayers[index] = value;
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            _removePlayer(index);
          },
        ),
      ),
    );
  }

  /// This method adds a new player to the list.
  void _addPlayer() {
    setState(() {
      // add focus node to list
      _focusNodes.add(FocusNode());
      // insert in list and in animated list
      _currentPlayers.add('');
      _listKey.currentState!.insertItem(_currentPlayers.length - 1);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scroll to bottom of list view
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
      );
      // and focus the new text field after it has been built
      FocusScope.of(context).requestFocus(_focusNodes.last);
    });
  }

  /// This method removes a player from the list.
  /// It takes an index as a parameter.
  void _removePlayer(int index) {
    setState(() {
      // remove from list
      final removedPlayer = _currentPlayers.removeAt(index);
      // remove from animated list after removing from list
      _listKey.currentState!.removeItem(
        index,
        (context, animation) =>
            _buildPlayerItem(removedPlayer, animation, index),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // remove focus node from list after setting state
      _focusNodes.removeAt(index);
    });
  }

  /// This method handles the event when the "Done Adding" button is pressed.
  void _doneAddingPressed() {
    // the done adding button is pressed
    // depending on where we come from, navigate to the correct route

    // coming from the game selection page to create a new game
    // or coming here directly from home page since there is no saved game state
    // so navigate to the game
    // and pop all routes until the main route
    if (_comingFromRoute == 'game-selection' ||
        _comingFromRoute == 'home-page') {
      NavigationUtils.pushNamedAndPopTillMain(context, '/game');
      // coming here from the main game to edit players list
      // so only pop page to get back
    } else if (_comingFromRoute == 'main-game') {
      NavigationUtils.popWhenPossible(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return DefaultScaffold(
      title: loc!.currentPlayersPageTitle,
      cutOffAtActionButton: true,
      actionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addPlayer',
            tooltip: loc.currentPlayersPageButtonAddPlayer,
            onPressed: _addPlayer,
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 8.0,
          ),
          FloatingActionButton(
            heroTag: 'doneAdding',
            backgroundColor: UIDefaults.colorYes,
            tooltip: loc.currentPlayersPageButtonDoneAdding,
            onPressed: _doneAddingPressed,
            child: const Icon(Icons.done),
          )
        ],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            int currentIndex = _focusNodes.indexWhere((node) => node.hasFocus);
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              // Shift focus to the previous text field
              if (currentIndex > 0) {
                FocusScope.of(context)
                    .requestFocus(_focusNodes[currentIndex - 1]);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              // Shift focus to the next text field
              if (currentIndex < _focusNodes.length - 1) {
                FocusScope.of(context)
                    .requestFocus(_focusNodes[currentIndex + 1]);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              // Remove the current text field
              if (currentIndex != -1) {
                _removePlayer(currentIndex);
              }
            }
          }
        },
        child: AnimatedList(
          key: _listKey,
          controller: _scrollController,
          initialItemCount: _currentPlayers.length,
          itemBuilder: (context, index, animation) {
            return _buildPlayerItem(_currentPlayers[index], animation, index);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // dispose focus nodes
    for (final node in _focusNodes) {
      node.dispose();
    }

    // change orientation back to normal
    UIUtils.setPreferredOrientation();
  }
}