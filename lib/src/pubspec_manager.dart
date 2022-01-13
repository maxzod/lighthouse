import 'dart:io';

import 'package:lighthouse/src/file_manager.dart';
import 'package:yaml/yaml.dart';

import 'package:yaml_edit/yaml_edit.dart';

class PubSpecManager {
  Future<void> setAssets(Iterable<String> assetsBefore, File file) async {
    const path = [
      /// the root tag
      'flutter',

      /// the tag to edit
      'assets',
    ];
    final assets = formatPaths(assetsBefore);

    /// read the content of `pubspec.yaml` file
    final pubspecContent = await file.readAsString();

    /// create editor to edit the `[flutter][assets]` tag
    final doc = YamlEditor(pubspecContent);

    /// this line will delete the old content
    /// and adds the new list
    /// ```yaml
    ///    flutter:
    ///     assets:
    ///     - assets/foo.png
    ///     - assets/bar.png
    /// ```
    // TODO :: wont work if the path is null on the real pubspec.yaml file
    doc.update(path, assets);
    // doc.appendToList(path, assets);

    /// save the pubspec.yaml file
    file.writeAsString(doc.toString());
  }

  Iterable<String> formatPaths(Iterable<String> list) {
    final result = <String>[];
    for (final e in list) {
      /// remove the `./` prefix from the path start

      result.add(
        e.replaceFirst('./', '').replaceFirst('.\\', '').replaceAll('\\', '/'),
      );
    }
    return result;
  }

  /// * returns true if this file in the yaml assets
  bool isInYamlAssets(String child, List<String> assets) {
    return assets
        .where((p) => FilesManager().isEnoughToUseParent(p, child))
        .isNotEmpty;
  }

  Future<Iterable<String>> getYamlAssets(File yamlFile) async {
    /// `pubspec.yaml` content as a [String]
    final content = await FilesManager().readFileContent(yamlFile);
    // convert to [YamlMap]
    final yaml = loadYaml(content) as YamlMap;
    return (yaml['flutter']['assets'] as YamlList?)?.map((e) => e.toString()) ??
        [];
  }

  Iterable<MapEntry> getAppDependencies() {
    final YamlMap? yaml =
        loadYaml(File('pubspec.yaml').readAsStringSync())['dependencies'];
    return yaml?.entries ?? [];
  }

  Future<YamlList> getPubspecAssetsYaml(
    File file,
  ) async =>
      loadYaml((await file.readAsString()))['flutter']['assets'];
}
