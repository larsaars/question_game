import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/ui_defaults.dart';
import 'package:question_game/utils/base_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/navigation_utils.dart';
import '../../widgets/default_scaffold.dart';

/// A page that simulates a game with a bomb.
/// The bomb has a timer that counts down to an explosion.
/// The page also includes audio effects for ticking and explosion.
class GameBombPage extends StatefulWidget {
  const GameBombPage({super.key});

  @override
  State<GameBombPage> createState() => _GameBombPageState();
}

class _GameBombPageState extends State<GameBombPage> {
  // The timer waiting for the bomb to explode
  Timer? _explosionTimer;

  // Audio players for ticking and explosion
  final _explosionAudioPlayer = AudioPlayer(),
      _tickingAudioPlayer = AudioPlayer();

  // App strings
  AppLocalizations? localizations;

  @override
  void initState() {
    super.initState();

    // Pop to last route if there is no game state
    if (GameStateHandler.currentGameState == null) {
      NavigationUtils.popWhenPossible(context);
    }

    // Set explosion audio source, after loading, start the countdown timer (30-60 seconds)
    _explosionAudioPlayer.setAsset('sounds/bomb_explosion.mp3').then((_) {
      _explosionTimer =
          Timer(Duration(seconds: 30 + BaseUtils.random.nextInt(31)), () {
        // Stop the ticking sound
        _tickingAudioPlayer.stop();
        // When the timer is done, play the explosion sound and pop the page
        _explosionAudioPlayer.play().then((_) => NavigationUtils.popWhenPossible(context));
      });
    });

    // Set ticking audio source, after loading, start the ticking sound (in a looping mode)
    _tickingAudioPlayer.setAsset('sounds/bomb_ticking_5secs.wav').then((_) {
      _tickingAudioPlayer
          .setLoopMode(LoopMode.one)
          .then((_) => _tickingAudioPlayer.play());
    });
  }

  @override
  void dispose() {
    // Cancel explosion timer
    _explosionTimer?.cancel();

    // Dispose audio players
    _explosionAudioPlayer.dispose();
    _tickingAudioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations ??= AppLocalizations.of(context);

    return PopScope(
      onPopInvoked: (_) => false, // Ignore back button
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
          child: Text(
            GameStateHandler.currentGameState?.currentQuestion?.value ?? '',
            style: UIDefaults.gameBodyTextStyle,
          ),
        ),
      ),
    );
  }
}