import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/database/database_handler.dart';
import 'package:question_game/utils/base_utils.dart';

import '../widgets/default_scaffold.dart';

class ChooseCategoriesPage extends StatefulWidget {
  const ChooseCategoriesPage({super.key});

  @override
  State<ChooseCategoriesPage> createState() => _ChooseCategoriesPageState();
}

class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  late final List _items = [];
  late AppLocalizations? loc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _initItems().then(
      (value) => setState(() {
        _loading = false;
      }),
    );
  }

  Future _initItems() async {
    // make list of categories from categories descriptor map
    for (var categoryKey in DataBaseHandler.categoriesDescriptor.keys) {
      final category = DataBaseHandler.categoriesDescriptor[categoryKey];
      _items.add({
        'text': category['name'],
        'color': category['color'],
        // set checked from pref value
        'checked': BaseUtils.prefs?.getBool('category_$categoryKey') ?? true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _items[index];
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
                        BaseUtils.prefs?.setBool('category_$index', value!);
                        // set new state (also in local ram list copy)
                        setState(() {
                          item['checked'] = value;
                        });
                      });
                },
              ));
  }
}
