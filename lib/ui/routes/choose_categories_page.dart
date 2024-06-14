import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:question_game/database/database_handler.dart';
import 'package:question_game/utils/base_utils.dart';

import '../widgets/default_scaffold.dart';

/// This is the ChooseCategoriesPage class which extends StatefulWidget.
/// This class is responsible for displaying the categories to the user.
class ChooseCategoriesPage extends StatefulWidget {
  /// Constructor for the ChooseCategoriesPage class.
  const ChooseCategoriesPage({super.key});

  /// Creates the mutable state for this widget at a given location in the tree.
  @override
  State<ChooseCategoriesPage> createState() => _ChooseCategoriesPageState();
}

/// This is the _ChooseCategoriesPageState class which extends State<ChooseCategoriesPage>.
/// This class is responsible for the state of the ChooseCategoriesPage.
class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  /// This is the list of items that will be displayed to the user.
  late final List _items = [];
  /// This is the localization object used for internationalization.
  late AppLocalizations? loc;
  /// This is a boolean value that indicates whether the page is loading or not.
  bool _loading = true;

  /// This method is called when this object is inserted into the tree.
  @override
  void initState() {
    super.initState();

    // Initialize the items and then set the loading state to false.
    _initItems().then(
      (value) => setState(() {
        _loading = false;
      }),
    );
  }

  /// This method is responsible for initializing the items.
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

  /// This method is responsible for building the widget tree.
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: AppLocalizations.of(context)!.chooseCategoriesPageTitle,
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
                  },
                );
              },
            ),
    );
  }
}