import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart' as ui_defaults;
import 'package:question_game/ui/widgets/loader_widget.dart';

import '../../database/database_handler.dart';
import '../widgets/centered_text_icon_button.dart';
import '../widgets/default_scaffold.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  String _titleText = '';
  String? _defaultTitleText;

  bool _withBang = false;

  @override
  void initState() {
    super.initState();

    // Create a timer that changes the text every n seconds
    // for the title to blink with a "!" at the end
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        // update text field
        _withBang = !_withBang;

        if (_withBang) {
          _titleText = '$_defaultTitleText!';
        } else {
          _titleText = _defaultTitleText ?? '';
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // cancel timer when the widget is disposed
    _timer.cancel();
  }

  Future _onStartLoading() async {
    // load the categories descriptor on app start
    await DataBaseHandler().loadCategoriesDescriptor();
  }

  @override
  Widget build(BuildContext context) {
    // default title text can only be here set (not in initState)
    // since it requires the context which is not available before
    _defaultTitleText ??= _titleText = AppLocalizations.of(context)!.appTitle;
    return DefaultScaffold(
      backButton: false,
      child: LoaderWidget(
        loadFunc: _onStartLoading,
        childFunc:() => Stack(
          children: [
            Center(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _titleText,
                        style: const TextStyle(
                          fontSize: 64,
                          fontFamily: 'alte_haas_grotesk',
                          fontWeight: FontWeight.w700,
                          color: ui_defaults.colorPrimary,
                        ),
                      ),
                    ),
                    CenteredTextIconButton(
                      icon: Icons.videogame_asset,
                      text: AppLocalizations.of(context)!.mainPageStartGame,
                      textColor: ui_defaults.colorPrimary,
                      iconColor: ui_defaults.colorPrimary,
                      onPressed:
                          () {}, // TODO below continue last game and play last game instance
                    ),
                    CenteredTextIconButton(
                      icon: Icons.category,
                      text:
                          AppLocalizations.of(context)!.mainPageChooseCategories,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/categories'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
