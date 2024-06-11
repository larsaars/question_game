import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/base_utils.dart';

import '../../../utils/navigation_utils.dart';
import '../../widgets/default_scaffold.dart';

class GameBombPage extends StatefulWidget {
  const GameBombPage({super.key});

  @override
  State<GameBombPage> createState() => _GameBombPageState();
}

class _GameBombPageState extends State<GameBombPage> {
  // the timer waiting for the bomb to explode
  Timer? _explosionTimer;

  // audio players for ticking and explosion
  final _explosionAudioPlayer = AudioPlayer(),
      _tickingAudioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      NavigationUtils.popWhenPossible(context);
    }

    // set explosion audio source, after loading, start the countdown timer (30-60 seconds)
    _explosionAudioPlayer.setAsset('sounds/bomb_explosion.mp3').then((_) {
      _explosionTimer =
          Timer(Duration(seconds: 30 + BaseUtils.random.nextInt(31)), () {
        // stop the ticking sound
        _tickingAudioPlayer.stop();
        // when the timer is done, play the explosion sound and pop the page
        _explosionAudioPlayer.play().then((_) => NavigationUtils.popWhenPossible(context));
      });
    });

    // set ticking audio source, after loading, start the ticking sound (in a looping mode)
    _tickingAudioPlayer.setAsset('sounds/bomb_ticking_5secs.wav').then((_) {
      _tickingAudioPlayer
          .setLoopMode(LoopMode.one)
          .then((_) => _tickingAudioPlayer.play());
    });
  }

  @override
  void dispose() {
    // cancel explosion timer
    _explosionTimer?.cancel();

    // dispose audio players
    _explosionAudioPlayer.dispose();
    _tickingAudioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => false, // ignore back button
      child: DefaultScaffold(
        backButtonIcon: Icons.keyboard_double_arrow_right,
        topRightWidget: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => NavigationUtils.popTillMain(context),
        ),
        child: Center(
          child: Text(
            GameStateHandler.currentGameState?.currentQuestion?.value ?? '',
            style: UIDefaults.gameBodyTextStyle,
          ),
        ),
      ),
    );
  }
}
