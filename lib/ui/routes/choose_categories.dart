import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/ui/ui_defaults.dart' as ui_defaults;
import 'package:question_game/ui/widgets/loader_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseCategoriesPage extends StatefulWidget {
  const ChooseCategoriesPage({super.key});

  @override
  State<ChooseCategoriesPage> createState() => _ChooseCategoriesPageState();
}

class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  late List? _items;
  late AppLocalizations? loc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _initItems() async {
    final loc = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();

    // and then init items as well
    _items = [
      {
        'text': loc!.categoryQuestion,
        'color': ui_defaults.colorCategoryQuestion
      },
      {'text': loc!.categoryPoll, 'color': ui_defaults.colorCategoryPoll},
      {'text': loc!.categoryBomb, 'color': ui_defaults.colorCategoryBomb},
      {'text': loc!.categoryYesOrNo, 'color': ui_defaults.colorCategoryYesOrNo},
      {
        'text': loc!.categoryChallenge,
        'color': ui_defaults.colorCategoryChallenge
      },
      {'text': loc!.categoryRule, 'color': ui_defaults.colorCategoryRule},
    ];

    // load values from prefs
    for (int i = 0; i < _items!.length; i++) {
      _items![i]['checked'] = prefs.getBool('category_$i') ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ui_defaults.DefaultScaffold(
      child: LoaderWidget(
        loadFunc: _initItems,
        childFunc: () => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _items?.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _items?[index];
            return CheckboxListTile(
                checkColor: item['color'],
                activeColor: item['color'],
                title: Text(
                  item['text'],
                  style: TextStyle(color: item['color']),
                ),
                value: item['checked'],
                onChanged: (bool? value) {
                  // update in prefs
                  SharedPreferences.getInstance().then(
                      (prefs) => prefs.setBool('category_$index', value!));
                  // set new state (also in local ram list copy)
                  setState(() {
                    item['checked'] = value;
                  });
                });
          },
        ),
      ),
    );
  }
}
