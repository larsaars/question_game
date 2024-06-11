import 'package:flutter/material.dart';

import '../../../database/gamestate_handler.dart';

class GameYesNoPage extends StatefulWidget {
  const GameYesNoPage({super.key});

  @override
  State<GameYesNoPage> createState() => _GameYesNoPageState();
}

class _GameYesNoPageState extends State<GameYesNoPage> {

  @override
  void initState() {
    super.initState();

    // pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
