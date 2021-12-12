import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:df_builder/df_builder.dart';
import 'package:lighthouse/src/config.dart';
import 'package:lighthouse/src/helpers/file.dart';
import 'package:lighthouse/src/helpers/pubspec.dart';
import 'package:lighthouse/src/helpers/yaml.dart';
import 'package:recase/recase.dart';

final _yamlAssets = <String>[];

class AssetsMakeCommand extends Command {
  /// command description
  @override
  String get description => 'make assets class Assets 🎁';

  /// command name
  @override
  String get name => 'assets:make';

  /// called when a user invokes `lh assets:make`
  @override
  Future<void> run() async {
    /// load yaml assets from `pubspec.yaml`
    /// to make sure this asset is added in pubspec.yaml or not `#2`
    _yamlAssets.addAll(getYamlAssets());

    /// assets.dart
    final df = DartFileBuilder(
      topComments: [kTopComment],
    );

    /// root class (`Assets`) getters
    final rootGetters = await buildClassGetters(
      dfBuilder: df,
      useStaticGetter: true,
    );

    /// root class `Asset`
    df.addClass(
      ClassBuilder(
        name: 'Asset',
        getters: rootGetters,
      ),
    );

    /// generated files
    if (!Directory('./lib/generated').existsSync()) {
      /// if the generated directory does not exist, create it
      await Directory('./lib/generated').create();
    }

    /// generate file
    final genFile = File('./lib/generated/assets.dart');

    /// if there is old assets folder delete it
    if (await genFile.exists()) await genFile.delete();

    /// creates new `assets.dart` file
    await genFile.writeAsString(df.toString());
  }

  /// end of the command class
}

/// scout the folder path
Future<List<ClassGetter>> buildClassGetters({
  /// * takes a builder because we might need to go deeper [recursive] because of the nested folders
  required DartFileBuilder dfBuilder,

  /// * path to start with (default is `./assets`)
  String path = 'assets',

  /// is this getters static (default is `false`)
  /// we need to use static getters to make sure the assets are accessible from the root class
  /// and the nested objects
  bool useStaticGetter = false,
}) async {
  /// directory children
  final children = await loadDirectoryFiles(path);

  /// getters of this directory
  final getters = <ClassGetter>[];

  for (final child in children) {
    if (child is File) {
      getters.add(ClassGetter(
        comments: _findFSTypeComment(child.path),
        type: 'String',
        name: findNameWithoutFormat(child.path),
        whatToReturn: '\'${child.path.replaceAll('\\', '/')}\'',
        isStatic: useStaticGetter,
      ));
    } else {
      /// it is a directory
      /// build the interface
      dfBuilder.addClass(
        await buildInterface(
          dfBuilder: dfBuilder,
          path: child.path,
        ),
      );
      getters.add(
        ClassGetter(
          comments: _findFSTypeComment(child.path),
          isStatic: useStaticGetter,
          name: findNameWithoutFormat(child.path),
          type: buildInterfaceName(child.path.pathCase.split('/').last),
          whatToReturn:
              "${buildInterfaceName(child.path.pathCase.split('/').last)}()",
        ),
      );
    }
  }
  return getters;
}

/// generate the interface name
String buildInterfaceName(String key) => '_${key.pascalCase}Interface';

Future<ClassBuilder> buildInterface({
  required String path,
  required DartFileBuilder dfBuilder,
}) async {
  final getters = await buildClassGetters(
    useStaticGetter: false,
    dfBuilder: dfBuilder,
    path: path,
  );

  return ClassBuilder(
    havePrivateConstructor: false,
    name: buildInterfaceName(path.pathCase.split('/').last),
    getters: getters,
  );
}

String findNameWithoutFormat(String path) {
  final name = findFileName(path).split('.').first;
  return name.camelCase;
}

/// return the comment based on the file
/// adds a deprecated comment if the file is not in the yaml Assets
String _findFSTypeComment(String child) {
  /// if is just a folder add this as comment
  if (!isFilePath(child)) return '/// * Directory';

  final fName = findFileName(child);

  /// *
  final result = findFileExtension(fName);

  String fComment = '/// * $result';

  /// * returns true if this file in the yaml assets
  final isInAssets = isInYamlAssets(child, _yamlAssets);

  return isInAssets
      ? fComment
      : '''$fComment
      @Deprecated('${child.replaceAll('\\', '/')} is not in your assets in pubspec.yaml')''';
}
