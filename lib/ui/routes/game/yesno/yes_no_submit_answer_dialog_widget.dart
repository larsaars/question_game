import 'package:flutter/material.dart';
import 'package:question_game/ui/routes/game/yesno/yesno_answer.dart';

class YesNoSubmitAnswerDialogWidget extends StatefulWidget {
  final StateSetter setState;
  final YesNoAnswer answer;

  const YesNoSubmitAnswerDialogWidget({
    super.key,
    required this.setState,
    required this.answer,
  });

  @override
  State<YesNoSubmitAnswerDialogWidget> createState() =>
      _YesNoSubmitAnswerDialogWidgetState();
}

class _YesNoSubmitAnswerDialogWidgetState
    extends State<YesNoSubmitAnswerDialogWidget> {
  @override
  Widget build(BuildContext context) {
    // tODO use widget.setState!!
    return const Placeholder();
  }
}
