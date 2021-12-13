import 'dart:io';

import 'package:df_builder/df_builder.dart';
import 'package:lighthouse/queen_map/queen_map.dart';
import 'package:recase/recase.dart';
import 'package:args/command_runner.dart';

import 'package:lighthouse/src/config.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';
import 'package:lighthouse/src/helpers/file.dart';
import 'package:lighthouse/src/helpers/locale.dart';
import 'package:lighthouse/src/helpers/nations_assets.dart';
import 'package:lighthouse/src/helpers/string.dart';

import '../../enums.dart';

const String kNationsExport = "export 'package:nations/nations.dart';";

class FullAssets {
  final Map<String, Map<String, Object?>> assets;

  FullAssets(this.assets);

  /// * returns supported locales in the application
  Iterable<String> get supportedLocales => assets.keys;
}

class TRMake extends Command {
  /// command description
  @override
  String get description => 'Creates the generated translation files/assets 🌍';

  /// command name
  @override
  String get name => 'tr:make';

  // /// * contains list of keys from all the languages

  /// called when a user invokes `lh tr:make`
  @override
  Future<void> run() async {
    /// project assets directory
    final jsonAssets = await loadDirectoryJsonFiles('./assets/lang/');

    /// list of supported locales
    final supportedLocales = findSupportedLocales(jsonAssets);

    /// contains translations from each language from project assets directory
    final _assetsFullHolder = <String, Map<String, Object?>>{};

    for (final locale in supportedLocales) {
      /// contains translations from each language from project assets directory
      final appAssets = await readJsonContent('./assets/lang/$locale.json');

      /// load the translations from `nations_assets`
      final nationsAssets = findAssetsFromNations(locale);
      _assetsFullHolder[locale] = mergeTwoMaps(nationsAssets, appAssets);
    }
    final fullAssets = FullAssets(_assetsFullHolder);
    validateLocalizationAssets(fullAssets);

    /// `tr.dart` file builder'
    final dfb = DartFileBuilder(
      exports: [kNationsExport],
      topComments: [kTopComment],
    );

    /// root class builder
    final trGetters = buildClassGetters(
      map: _assetsFullHolder,
      dfBuilder: dfb,
      useStaticGetters: true,
    );

    dfb.addClass(
      /// root class
      ClassBuilder(
        name: 'Tr',
        havePrivateConstructor: true,
        getters: trGetters,
      ),
    );

    /// generated files
    if (!Directory('./lib/generated').existsSync()) {
      await Directory('./lib/generated').create();
    }
    final genFile = File('./lib/generated/tr.dart');

    // if there is old file , delete it
    if (await genFile.exists()) await genFile.delete();

    await genFile.writeAsString(dfb.toString());
  }

  void validateLocalizationAssets(
    /// `key` => Locale name
    /// `value` =>  Locale translations
    FullAssets fullAssets,
  ) {
    final buggedKeys = <TrException>[];
    for (final lang in fullAssets.supportedLocales) {
      print('will validate translations');

      for (final key in fullAssets.assets[lang]!.keys) {
        buggedKeys.addAll(
          findKeyProblem(
            key: key,
            fullAssets: fullAssets,
          ),
        );
      }
    }

    if (buggedKeys.isNotEmpty) throw TrExceptionsList(buggedKeys);
  }

  // end of the command
}

ClassBuilder buildInterface(
  String key,
  Map<String, dynamic> map,
  DartFileBuilder dfBuilder, {
  List<String> parents = const [],
}) {
  final getters = buildClassGetters(
    // TODO :: why only arabic
    map: {'ar': map},
    dfBuilder: dfBuilder,
    parents: parents,
  );

  return ClassBuilder(
    havePrivateConstructor: false,
    name: buildInterfaceName(key),
    classProps: [
      ClassProp(
        addToConstructor: true,
        name: 'key',
        type: 'String',
      )
    ],
    getters: getters,
  );
}

/// converts the key to the interface name
String buildInterfaceName(String key) => '_${key.pascalCase}Interface';

List<ClassGetter> buildClassGetters({
  List<String> parents = const <String>[],
  required Map<String, Map<String, dynamic>> map,
  required DartFileBuilder dfBuilder,
  bool useStaticGetters = false,
}) {
  final getters = <ClassGetter>[];
  for (final key in map.values.first.keys) {
    final newParents = [...parents, key];
    final valueType = validateFelidType(
      key: key,
      value: map.values.first[key],
      language: key,
    );
    if (valueType == ValueType.string) {
      getters.add(
        ClassGetter(
          comments: buildKeyComments(key, map),
          isStatic: useStaticGetters,
          name: key == 'this' ? 'name' : key,
          type: 'String',
          whatToReturn: buildKeyWithParents(key, newParents),
        ),
      );
    } else if (valueType == ValueType.nested) {
      dfBuilder.addClass(
        buildInterface(key, map.values.first[key], dfBuilder,
            parents: newParents),
      );
      getters.add(
        ClassGetter(
          comments: '/// * Nested 🕸',
          isStatic: useStaticGetters,
          name: key,
          type: buildInterfaceName(key),
          whatToReturn: "${buildInterfaceName(key)}('$key')",
        ),
      );
    }
  }
  return getters;
}

String buildKeyComments(
  String key,
  Map<String, dynamic> fullTranslations,
) {
  final buffer = StringBuffer();
  for (final lang in fullTranslations.keys) {
    buffer.writeln('  /// * `$lang` => `${fullTranslations[lang]![key]}` ');
  }
  return buffer.toString().trim();
}

/// return the key with parents as string separated by `.`
/// example :
///  ```json
///         "key1": {
///            "key2": {
///               "key3": "some value"
///           }
///      }
/// ```
///  will be => `[key1,key2,key3]`  will be `key1.key2.key3`
String buildKeyWithParents(String key, List<String> parents) {
  if (parents.length < 2) {
    /// is not nested
    return "'$key'";
  } else {
    return "'${parents.join('.')}'";
  }
}
