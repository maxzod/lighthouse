import 'dart:io';

import 'package:df_builder/df_builder.dart';
import 'package:lighthouse/src/managers/recase.dart';
import 'package:lighthouse/src/mixins.dart';
import 'package:recase/recase.dart';

import '../../config.dart';
import '../../managers/file_manager.dart';
import '../../managers/pubspec_manager.dart';

class AssetsMakeCommand extends LightHouseCommand {
  final PubSpecManager yamlManager;
  final FilesManager filesManager;
  final RecaseManager recaseManager;

  AssetsMakeCommand({
    required this.yamlManager,
    required this.filesManager,
    required this.recaseManager,
  });
  final _yamlAssets = <String>[];
  String get outputPath => 'lib/generated/assets.dart';
  String get pubspecPath => 'pubspec.yaml';
  String get assetsPath => 'assets';
  String get rootName => 'Assets';

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
    _yamlAssets.addAll(await yamlManager.getYamlAssets(File(pubspecPath)));

    /// assets.dart
    final df = DartFileBuilder(
      topComments: [kTopComment],
    );

    /// root class (`Assets`) getters
    final rootGetters = await buildClassGetters(
      dfBuilder: df,
      useStaticGetter: true,
      path: assetsPath,
    );

    /// root class `Asset`
    df.addClass(
      ClassBuilder(
        name: rootName,
        getters: rootGetters,
      ),
    );

    /// * generate file
    final genFile = File(outputPath);

    /// * if there is old assets folder delete it
    if (await genFile.exists()) await genFile.delete();
    genFile.createSync(recursive: true);

    /// * creates new `assets.dart` file
    await genFile.writeAsString(df.toString());
  }

  @override
  String get successMessage => 'assets.dart generated successfully 🎁';

  /// end of the command class

  /// scout the folder path
  Future<List<ClassGetter>> buildClassGetters({
    /// * takes a builder because we might need to go deeper [recursive] because of the nested folders
    required DartFileBuilder dfBuilder,

    /// * path to start with (default is `./assets`)
    required String path,

    /// is this getters static (default is `false`)
    /// we need to use static getters to make sure the assets are accessible from the root class
    /// and the nested objects
    bool useStaticGetter = false,
  }) async {
    /// directory children
    final children = filesManager.loadDirectoryFiles(Directory(path));

    /// getters of this directory
    final getters = <ClassGetter>[];

    for (final child in children) {
      var fileName = recaseManager.findNameWithoutFormat(child.path);
      if (fileName.isEmpty) continue;

      if (child is File) {
        getters.add(ClassGetter(
          comments: await findFSTypeComment(child.path, _yamlAssets),
          type: 'String',
          name: fileName,
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
            comments: await findFSTypeComment(child.path, _yamlAssets),
            isStatic: useStaticGetter,
            name: fileName,
            type: recaseManager
                .buildInterfaceName(child.path.pathCase.split('/').last),
            whatToReturn:
                "${recaseManager.buildInterfaceName(child.path.pathCase.split('/').last)}()",
          ),
        );
      }
    }
    return getters;
  }

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
      name: recaseManager.buildInterfaceName(path.pathCase.split('/').last),
      getters: getters,
    );
  }

  /// return the comment based on the file
  /// adds a deprecated comment if the file is not in the yaml Assets
  Future<String> findFSTypeComment(
    String path,
    List<String> yamlAssets,
  ) async {
    /// if is just a folder add this as comment
    if (await filesManager.isDirPath(path)) return '/// * Directory';

    final fName = filesManager.findFileName(path);

    /// *
    final extension = filesManager.findFileExtension(fName);

    String fComment = '/// `$extension`';

    /// * returns true if this file in the yaml assets
    final isInAssets = yamlManager.isInYamlAssets(path, yamlAssets);

    /// to annotate it as deprecated
    return isInAssets
        ? fComment
        : """$fComment
@Deprecated('${path.replaceAll('\\', '/')} is not in your assets in pubspec.yaml')""";
  }
}
