import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:question_game/ui/ui_defaults.dart';

/// Displays an About dialog with application details.
///
/// The dialog includes the application icon, name, version, and legal information.
/// The legal information is loaded from a text file in the application's assets.
///
/// [context] is the BuildContext from which the dialog is shown.
Future<void> showMyAboutDialog(BuildContext context) async {
  final loc = AppLocalizations.of(context); // strings

  showAboutDialog(
    // ignore: use_build_context_synchronously
    context: context,
    applicationIcon: Image.asset(
      'imgs/app_icon.png',
      height: UIDefaults.defaultIconSize,
    ),
    applicationName: loc!.appTitle,
    applicationVersion: loc.appVersion,
    applicationLegalese: await rootBundle.loadString(
        'licenses/app_license_text.txt'),
  );
}

/// Registers a license with the LicenseRegistry.
///
/// The license text is loaded from a text file in the application's assets.
///
/// [name] is the name of the license.
/// [assetPath] is the path to the license text file in the application's assets.
Future<void> _registerLicense(String name, String assetPath) async {
  String licenseText = await rootBundle.loadString(assetPath);  // load text from assets
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([name], licenseText);
  });
}

/// Registers multiple licenses with the LicenseRegistry.
///
/// The licenses are registered by calling the [_registerLicense] function with the name of the license and the path to the license text file in the application's assets.
Future<void> registerLicenses() async {
  _registerLicense('Alte Haas Grotesk (Font)', 'licenses/License_Alte_Haas_Grotesk.txt');
  _registerLicense('Louis George Cafe (Font)', 'licenses/License_Louis_George_Cafe.txt');
  _registerLicense('Flaticon', 'licenses/flaticon.txt');
}