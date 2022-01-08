// import 'package:args/command_runner.dart';
// import 'package:lighthouse/src/helpers/locale.dart';
// import 'package:readable/readable.dart';

// import 'package:lighthouse/src/helpers/file.dart';

// class TrValidateCommand extends Command {
//   @override
//   String get description => 'validates your assets';

//   @override
//   String get name => 'tr:validate';

//   @override
//   Future<void> run() async {
//     /// project assets directory
//     final jsonAssets = await loadDirectoryJsonFiles('./assets/lang/');

//     /// list of supported locales
//     final supportedLocales = findSupportedLocales(jsonAssets);

//     /// contains translations from each language from project assets directory
//     final fullAssets = <String, Map<String, Object?>>{};

//     final List<String> fullKeys = <String>[];

//     for (final locale in supportedLocales) {
//       /// contains translations from each language from project assets directory
//       fullAssets[locale] = await readJsonContent('./assets/lang/$locale.json');

//       fullKeys.addAll(flatMapKeys(fullAssets[locale]!));
//     }

//     validateLocalizationAssets(
//       /// to red of duplicates
//       fullKeys.toSet().toList(),

//       /// full assets map with the locales
//       fullAssets,
//     );
//   }

//   /// end of the command
// }
