import 'dart:io';

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
}
