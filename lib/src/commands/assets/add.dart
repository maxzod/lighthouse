import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:lighthouse/src/helpers/file.dart';
import 'package:yaml_edit/yaml_edit.dart';

class AssetsAddCommand extends Command {
  /// command description
  @override
  String get description => 'add assets folder content to pubspec.yaml';

  /// command name
  @override
  String get name => 'assets:add';
  @override
  Future<void> run() async {
    /// contains the assets directory children in flat list
    /// ```dart
    /// [
    ///  'assets/foo.png',
    ///  'assets/bar.png',
    /// 'assets/images/logo_black.png',
    /// 'assets/images/logo_white.png',
    /// 'assets/images/products/prod_1.png',
    /// 'assets/images/products/prod_2.png',
    /// 'assets/images/products/prod_3.png',
    ///]
    ///```
    final assetsDirChildren = <String>[];

    /// find root assets `./assets` children
    final items = await loadDirectoryFiles('./assets');

    /// extract the children content
    for (final fse in items) {
      final list = await findInnerContent(fse);

      /// group them in one list
      assetsDirChildren.addAll(list);
    }

    /// read the content of `pubspec.yaml` file
    final pubspecContent = await File('./pubspec.yaml').readAsString();

    /// create editor to edit the `[flutter][assets]` tag
    final doc = YamlEditor(pubspecContent);

    final newAssets = assetsDirChildren.map(
      (e) {
        String path = e;

        /// remove the `./` prefix from the path start
        if (e.startsWith('./')) path = e.substring(2);

        return path.replaceAll('\\', '/');
      },
    ).toList();

    /// this line will delete the old content
    /// and adds the new list
    /// ```yaml
    ///    flutter:
    ///     assets:
    ///     - assets/foo.png
    ///     - assets/bar.png
    /// ```
    doc.update(
      [
        /// the root tag
        'flutter',

        /// the tag to edit
        'assets',
      ],
      newAssets,
    );

    /// save the pubspec.yaml file
    File('./pubspec.yaml').writeAsString(doc.toString());
  }

  /// end of the command
}

/// give it a file system entity
/// it will return a list that contains the paths to every single file in that `FileSystemEntity`
Future<List<String>> findInnerContent(FileSystemEntity fse) async {
  /// if this is a file return the path
  if (isFilePath(fse.path)) return [fse.path];

  /// read the directory content
  final children = await loadDirectoryFiles(fse.path);

  /// to contains the children of this Directory
  final childrenPaths = <String>[];
  for (final child in children) {
    /// if this is a file add the path to the children's list
    if (isFilePath(child.path)) {
      childrenPaths.add(child.path);
    } else {
      /// recursive call to find the children of this children
      final newPaths = await findInnerContent(child);
      childrenPaths.addAll(newPaths);
    }
  }

  return childrenPaths;
}
