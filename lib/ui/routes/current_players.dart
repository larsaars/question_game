import 'package:flutter/material.dart';
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
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: ListTile(
        title: TextField(
          controller: TextEditingController(text: player),
          focusNode: _focusNodes[index],
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.currentPlayersPagePlayerName,
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
    // insert in list and in animated list
    _currentPlayers.add('');
    _listKey.currentState!.insertItem(_currentPlayers.length - 1);
    // add focus node to list
    _focusNodes.add(FocusNode());
    // focus the new text field
    FocusScope.of(context).requestFocus(_focusNodes.last);
  }

  void _removePlayer(int index) {
    // remove from list and animated list
    String removedPlayer = _currentPlayers.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildPlayerItem(removedPlayer, animation, index),
    );
    // remove focus node from list
    _focusNodes.removeAt(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    // save the player list to shared preferences
    // on dispose
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setStringList('currentPlayersList', _currentPlayers));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      actionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.currentPlayersPageAddPlayer,
        onPressed: () => _addPlayer,
        child: const Icon(Icons.add),
      ),
      child: LoaderWidget(
        loadFunc: _initPlayerList,
        childFunc: () => AnimatedList(
          key: _listKey,
          initialItemCount: _currentPlayers.length,
          itemBuilder: (context, index, animation) {
            return _buildPlayerItem(_currentPlayers[index], animation, index);
          },
        ),
      ),
    );
  }
}
