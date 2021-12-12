import 'dart:io';

import 'package:args/command_runner.dart';
// import 'package:json2yaml/json2yaml.dart';
import 'package:lighthouse/src/helpers/file.dart';
// import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class AssetsAddCommand extends Command {
  @override
  String get description => 'add assets folder content to pubspec.yaml';

  @override
  String get name => 'assets:add';
  @override
  Future<void> run() async {
    final newPaths = <String>[];
    final items = await loadDirectoryFiles('./assets');
    for (final fse in items) {
      final list = await findInnerContent(fse);
      newPaths.addAll(list);
    }

    final pubspecContent = await File('./pubspec.yaml').readAsString();
    final doc = YamlEditor(pubspecContent);

    doc.update(
      ['flutter', 'assets'],
      newPaths.map((e) {
        String path = e;
        if (e.startsWith('./')) {
          path = e.substring(2);
        }
        return path.replaceAll('\\', '/');
      }).toList(),
    );

    File('./pubspec.yaml').writeAsString(doc.toString());
  }
}

Future<List<String>> findInnerContent(FileSystemEntity fse) async {
  if (isFilePath(fse.path)) return [fse.path];
  final children = await loadDirectoryFiles(fse.path);
  final paths = <String>[];
  for (final child in children) {
    if (isFilePath(child.path)) {
      paths.add(child.path);
    } else {
      final newPaths = await findInnerContent(child);
      paths.addAll(newPaths);
    }
  }
  return paths;
}
