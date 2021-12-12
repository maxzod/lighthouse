import 'dart:io';

import 'package:df_builder/df_builder.dart';
import 'package:lighthouse/src/config.dart';
import 'package:lighthouse/src/helpers/file.dart';
import 'package:lighthouse/src/helpers/locale.dart';
import 'package:lighthouse/src/helpers/map.dart';
import 'package:lighthouse/src/helpers/string.dart';
import 'package:nations_assets/assets/ar.dart';
import 'package:nations_assets/assets/en.dart';
import 'package:nations_assets/assets/es.dart';
import 'package:recase/recase.dart';

import 'package:args/command_runner.dart';

import '../../enums.dart';

Map<String, Object> findAssetsFromNations(String locale) {
  switch (locale) {
    case 'ar':
      return arAssets;
    case 'en':
      return enAssets;
    case 'es':
      return esAssets;
    default:
      return {};
  }
}

class TR extends Command {
  static const String kNationsExport = "export 'package:nations/nations.dart';";

  /// command description
  @override
  String get description => 'Creates the generated translation files/assets 🌍';

  /// command name
  @override
  String get name => 'tr:make';

  /// * contains list of keys from all the languages
  final keys = <String>[];

  /// called when a user invokes `lh tr:make`
  @override
  Future<void> run() async {
    /// project assets directory
    final jsonAssets = await loadDirectoryJsonFiles('./assets/lang/');

    /// list of supported locales
    final supportedLocales = findSupportedLocales(jsonAssets);

    /// contains translations from each language from project assets directory
    final assetsFull = <String, Map<String, dynamic>>{};

    for (final locale in supportedLocales) {
      final appAssets = await readJsonContent('./assets/lang/$locale.json');
      final nationsAssets = findAssetsFromNations(locale);
      assetsFull[locale] = mergeTwoMaps(nationsAssets, appAssets);
    }

    for (final key in keys) {
      findMissingKeys(
        key: key,
        langsAssets: assetsFull,
        supportedLangs: supportedLocales,
      );
    }

    /// `tr.dart` file builder'
    final dfb = DartFileBuilder(
      exports: [kNationsExport],
      topComments: [kTopComment],
    );

    /// root class builder
    final trGetters = buildClassGetters(
      map: assetsFull,
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
        key: key, value: map.values.first[key], language: key);
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
  Map<String, Map<String, dynamic>> first,
) {
  final buffer = StringBuffer();
  for (final lang in first.keys) {
    buffer.writeln('  /// * `$lang` => `${first[lang]![key]}` ');
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

/// *  return supported locales based on files names
List<String> findSupportedLocales(List<FileSystemEntity> files) {
  return files
      .map((f) => f.path.split('/').last.replaceAll('.json', ''))
      .toList();
}
