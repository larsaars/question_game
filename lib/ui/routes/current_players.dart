import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_game/ui/ui_defaults.dart' as ui_defaults;
import 'package:question_game/ui/widgets/loader_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/default_scaffold.dart';

class CurrentPlayersPage extends StatefulWidget {
  const CurrentPlayersPage({super.key});

  @override
  State<CurrentPlayersPage> createState() => _CurrentPlayersPageState();
}

class _CurrentPlayersPageState extends State<CurrentPlayersPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<String> _currentPlayers;
  List<FocusNode> _focusNodes = [];

  Future _initPlayerList() async {
    // load list from prefs
    final prefs = await SharedPreferences.getInstance();
    _currentPlayers = prefs.getStringList('currentPlayersList') ?? [];
    // init focus nodes list
    _focusNodes = List.generate(_currentPlayers.length, (_) => FocusNode());
  }

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

  void _addPlayer() {
    setState(() {
      // add focus node to list
      _focusNodes.add(FocusNode());
      // insert in list and in animated list
      _currentPlayers.add('');
      _listKey.currentState!.insertItem(_currentPlayers.length - 1);
    });

    // focus the new text field after it has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes.last);
    });
  }

  void _removePlayer(int index) {
    setState(() {
      String removedPlayer =
          _currentPlayers.removeAt(index); // remove from list
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    // save the player list to shared preferences
    // on dispose
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('currentPlayersList', _currentPlayers);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      actionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.currentPlayersPageAddPlayer,
        onPressed: _addPlayer,
        child: const Icon(Icons.add),
      ),
      child: LoaderWidget(
        loadFunc: _initPlayerList,
        childFunc: () => RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              int currentIndex =
                  _focusNodes.indexWhere((node) => node.hasFocus);
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
            initialItemCount: _currentPlayers.length,
            itemBuilder: (context, index, animation) {
              return _buildPlayerItem(_currentPlayers[index], animation, index);
            },
          ),
        ),
      ),
    );
  }
}
