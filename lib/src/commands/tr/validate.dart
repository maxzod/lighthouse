import 'dart:io';

import 'package:lighthouse/src/helpers/locale.dart';
import 'package:readable/readable.dart';

import '../../file_manager.dart';
import '../../mixins.dart';
import '../../pubspec_manager.dart';

class TrValidateCommand extends LightHouseCommand {
  final PubSpecManager yamlManager;
  final FilesManager filesManager;

  TrValidateCommand({
    required this.yamlManager,
    required this.filesManager,
  });
  @override
  String get description => 'validates your assets';

  @override
  String get name => 'tr:validate';

  @override
  Future<void> run() async {
    /// project assets directory
    final jsonAssets =
        filesManager.loadDirectoryJsonFiles(Directory('assets/lang/'));

    /// list of supported locales
    final supportedLocales = filesManager.findSupportedLocales(jsonAssets);

    /// contains translations from each language from project assets directory
    final fullAssets = <String, Map<String, Object?>>{};

    final List<String> fullKeys = <String>[];

    for (final locale in supportedLocales) {
      /// contains translations from each language from project assets directory
      fullAssets[locale] =
          await filesManager.readJsonContent(File('assets/lang/$locale.json'));

      fullKeys.addAll(flatMapKeys(fullAssets[locale]!));
    }

    validateLocalizationAssets(
      /// to red of duplicates
      fullKeys.toSet().toList(),

      /// full assets map with the locales
      fullAssets,
    );
  }

  @override
  String get successMessage => 'All translations are valid';

  /// end of the command
}
