import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:question_game/ui/ui_defaults.dart' as ui_defaults;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;

void showMyAboutDialog(BuildContext context) async {
  final loc = AppLocalizations.of(context); // strings

  showAboutDialog(
    context: context,
    applicationIcon: Image.asset(
      'imgs/app_icon.png',
      height: ui_defaults.defaultIconSize,
    ),
    applicationName: loc!.appTitle,
    applicationVersion: loc.appVersion,
    applicationLegalese: await rootBundle.loadString(
        'licenses/app_license_text.txt'),
  );
}

Future<void> _registerLicense(String name, String assetPath) async {
  String licenseText = await rootBundle.loadString(assetPath);  // load text from assets
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([name], licenseText);
  });
}

Future<void> registerLicenses() async {
  _registerLicense('Alte Haas Grotesk (Font)', 'licenses/License_Alte_Haas_Grotesk.txt');
  _registerLicense('Louis George Cafe (Font)', 'licenses/License_Louis_George_Cafe.txt');
}