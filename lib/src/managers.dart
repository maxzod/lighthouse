import 'dart:io';

import 'package:yaml_edit/yaml_edit.dart';

import 'helpers/file.dart';

class PubSpecManager {
  Future<void> setAssets(Iterable<String> assetsBefore) async {
    final assets = formatPaths(assetsBefore);

    /// read the content of `pubspec.yaml` file
    final pubspecContent = await File('./pubspec.yaml').readAsString();

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
    doc.update(
      [
        /// the root tag
        'flutter',

        /// the tag to edit
        'assets',
      ],
      assets,
    );

    /// save the pubspec.yaml file
    File('./pubspec.yaml').writeAsString(doc.toString());
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
}

class FilesManager {
  /// give it a file system entity
  /// it will return a list that contains the paths to every single file in that `FileSystemEntity`
  List<String> findInnerContent(FileSystemEntity fse) {
    /// if this is a file return the path
    if (isFilePath(fse.path)) return [fse.path];

    /// read the directory content
    final children = loadDirectoryFiles(fse.path);

    /// to contains the children of this Directory
    final childrenPaths = <String>[];
    for (final child in children) {
      /// if this is a file add the path to the children's list
      if (isFilePath(child.path)) {
        childrenPaths.add(child.path);
      } else {
        /// recursive call to find the children of this children
        final newPaths = findInnerContent(child);
        childrenPaths.addAll(newPaths);
      }
    }

    return childrenPaths;
  }

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
  List<String> removeUnNecessaryChildren(List<String> list) {
    List<String> holder = [];
    for (final path in list) {
      if (path.startsWith('.')) continue;

      if (isFilePath(path)) {
        final newPath = path.split('/');
        if (newPath.last.startsWith('.')) continue;
        newPath.removeLast();
        holder.add('${newPath.join('/')}/');
      } else {
        holder.add(path);
      }
    }
    return holder.toSet().toList();
  }

  List<String> dirChildren(Directory directory) {
    final assets = <String>[];

    /// extract the children content
    for (final fse in (findInnerContent(directory))) {
      final list = findInnerContent(File(fse));

      /// group them in one list
      assets.addAll(list);
    }
    return assets;
  }
}
