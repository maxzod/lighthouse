// import 'dart:io';

// import 'package:df_builder/df_builder.dart';
// import 'package:lighthouse/src/commands/tr/fff.dart';
// import 'package:lighthouse/src/helpers/locale.dart';
// import 'package:readable/readable.dart' hide mergeTwoMaps;
// import 'package:lighthouse/src/config.dart';
// import 'package:lighthouse/src/helpers/map.dart';
// import 'package:readable/readable.dart';
// import 'package:recase/recase.dart';
// import 'package:args/command_runner.dart';

// import 'package:lighthouse/src/helpers/file.dart';
// import 'package:lighthouse/src/helpers/nations_assets.dart';
// import 'package:lighthouse/src/types.dart';

// const String kNationsExport = "export 'package:nations/nations.dart';";

// class TRMakeCommand extends Command {
//   /// command description
//   @override
//   String get description => 'Creates the generated translation files/assets 🌍';

//   /// command name
//   @override
//   String get name => 'tr:make';

//   /// called when a user invokes `lh tr:make`
//   @override
//   Future<void> run() async {
//     /// project assets directory
//     final jsonAssets = await loadDirectoryJsonFiles('./assets/lang/');

//     /// list of supported locales
//     final supportedLocales = findSupportedLocales(jsonAssets);

//     /// contains translations from each language from project assets directory
//     final FullAssets fullAssets = {};

//     final List<String> fullKeys = <String>[];

//     for (final locale in supportedLocales) {
//       /// contains translations from each language from project assets directory
//       final appAssets = await readJsonContent('./assets/lang/$locale.json');

//       /// load the translations from `nations_assets`
//       final nationsAssets = findAssetsFromNations(locale);

//       fullAssets[locale] = mergeTwoMaps(nationsAssets, appAssets) ?? {};
//       fullKeys.addAll(flatMapKeys(fullAssets[locale]!));
//     }

//     validateLocalizationAssets(
//       /// to rid of duplicate
//       fullKeys.toSet().toList(),
//       fullAssets,
//     );

//     /// root class builder
//     final allDFB = convertMapToDartFile(
//       fullAssets: fullAssets,
//       map: fullAssets[fullAssets.keys.first]!,
//       name: 'Tr',
//       useStaticGetters: true,
//     );

//     /// generated files
//     if (!Directory('./lib/generated').existsSync()) {
//       await Directory('./lib/generated').create();
//     }
//     final genFile = File('./lib/generated/tr.dart');

//     // if there is old file , delete it
//     if (await genFile.exists()) await genFile.delete();

//     await genFile.writeAsString('$kTopComment\n$kNationsExport\n$allDFB');
//   }
//   // end of the command

// }

// /// converts the key to the interface name
// String buildInterfaceName(String key) => '_${key.pascalCase}Interface';

// String buildKeyComments(
//   String flatName,
//   FullAssets fullAssets,
// ) {
//   final buffer = StringBuffer();

//   for (final lang in fullAssets.keys) {
//     final value = findInMap(flatName, fullAssets[lang] ?? {});
//     buffer.writeln('/// `$lang` => `$value`');
//   }
//   return buffer.toString().trim();
// }

// DartFileBuilder convertMapToDartFile({
//   List<String> parents = const [],
//   required String name,
//   required Map<String, Object?> map,
//   bool useStaticGetters = false,
//   required FullAssets fullAssets,
// }) {
//   final getters = <ClassGetter>[];
//   final file = DartFileBuilder();

//   for (final key in map.keys) {
//     final newParents = [...parents, key];

//     if (map[key] is String) {
//       // getters.add(ClassGetter(
//       //   comments: buildKeyComments(buildFlatKey(key, newParents), fullAssets),
//       //   isStatic: useStaticGetters,
//       //   name: key == 'this' ? 'name' : key,
//       //   type: 'String',
//       //   whatToReturn: "'${buildFlatKey(key, newParents)}'.tr",
//       // ));
//     } else if (map[key] is Map<String, Object?>) {
//       final fileBuilder = convertMapToDartFile(
//         name: buildFlatKey(key, newParents),
//         fullAssets: fullAssets,
//         map: map[key] as Map<String, Object?>,
//         parents: newParents,
//       );
//       for (final newInterface in fileBuilder.classes) {
//         file.addClass(newInterface);
//       }
//     } else {
//       // this should never be called
//       throw Exception('''
//       unexpected type please open issue with you assets/lang folder 💙
//       ''');
//     }
//   }
//   final mapClass = ClassBuilder(
//     name: name,
//     getters: buildGetters(
//       fullAssets: fullAssets,
//       map: map,
//       parents: parents,
//       name: name,
//       useStaticGetters: useStaticGetters,
//     ),
//     // getters: getters,
//   );
//   return file..addClass(mapClass);
// }

// List<ClassGetter> buildGetters({
//   List<String> parents = const [],
//   required String name,
//   required Map<String, Object?> map,
//   bool useStaticGetters = false,
//   required FullAssets fullAssets,
// }) {
//   final getters = <ClassGetter>[];
//   for (final key in map.keys) {
//     final newParents = [...parents, key];

//     if (map[key] is String) {
//       getters.add(ClassGetter(
//         comments: buildKeyComments(buildFlatKey(key, newParents), fullAssets),
//         isStatic: useStaticGetters,
//         name: key == 'this' ? 'name' : key,
//         type: 'String',
//         whatToReturn: "'${buildFlatKey(key, newParents)}'.tr",
//       ));
//     } else if (map[key] is Map) {
//       getters.add(ClassGetter(
//         comments: '/// * Nested 🕸',
//         isStatic: useStaticGetters,
//         name: key,
//         type: buildFlatKey(key, newParents).pascalCase,
//         whatToReturn: "${buildFlatKey(key, newParents).pascalCase}()",
//       ));
//     }
//   }
//   return getters;
// }
