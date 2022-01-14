import 'dart:io';

import 'package:lighthouse/src/exceptions/file.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
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
    return (yaml['flutter']?['assets'] as YamlList?)
            ?.map((e) => e.toString()) ??
        [];
  }

  Iterable<MapEntry> getPubspecDependencies(
    File file,
  ) {
    final yaml = loadYaml(file.readAsStringSync())?['dependencies'] as YamlMap?;
    return yaml?.entries ?? [];
  }

  Future<List<String>> findUsedPackages(File pubspec) async {
    final usedPackages = getPubspecDependencies(pubspec).toList();
    if (usedPackages.isEmpty) return [];
    return usedPackages.map((e) => e.key as String).toList();
  }

  Future<List<String>> findUnUsedPackages(File pubspec, Directory dir) async {
    final usedPackages = await findUsedPackages(pubspec);

    final projectFiles = await FilesManager().girDirectoryChildrenFlat(dir);
    for (final projectFile in projectFiles) {
      final fileContent = await projectFile.readAsString();
      final toRemove = <String>[];
      for (final package in usedPackages) {
        if (fileContent.contains('package:$package/')) {
          toRemove.add(package);
        }
      }
      usedPackages.removeWhere((element) => toRemove.contains(element));
    }
    return usedPackages.map((element) => element).toList();
  }

  Future<void> removeDependencies(
    File pubspec,
    List<String> packages,
  ) async {
    if (!(await pubspec.exists())) throw FileDoesNotExist(pubspec.path);
    // update pubspec.yaml
    /// read the content of `pubspec.yaml` file
    final pubspecContent = await pubspec.readAsString();

    /// create editor to edit the `[flutter][assets]` tag
    final doc = YamlEditor(pubspecContent);
    for (final package in packages) {
      doc.remove(['dependencies', package]);
    }

    /// this line will delete the old content

    /// save the pubspec.yaml file
    await pubspec.writeAsString(doc.toString());
  }
}
