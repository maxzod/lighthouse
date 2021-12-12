import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:lighthouse/src/helpers/file.dart';
import 'package:lighthouse/src/helpers/yaml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class AssetsAddCommand extends Command {
  @override
  String get description => 'add assets folder content to pubspec.yaml';

  @override
  String get name => 'assets:add';
  @override
  Future<void> run() async {
    final newPathes = <String>[];
    final items = await loadDirectoryFiles('./assets');
    for (final fse in items) {
      final list = await findInnerContent(fse);
      newPathes.addAll(list);
    }
    // print(newPathes);
    final yamlAssets = getYamlAssets();
    final yaml = loadYaml(File('./pubspec.yaml').readAsStringSync());

    final yamlEditor = YamlEditor(jsonEncode(yaml));
    yamlEditor.update(['flutter','assets'],
newPathes.map((e) => ''));
    
    // yamlEditor.appendToList(
    //   ['flutter', 'assets'],
    //   newPathes,
    // );

    File('./pubspec2.yaml').delete();
    File('./pubspec2.yaml').create();
    File('./pubspec2.yaml')
        .writeAsString(json2yaml(jsonDecode(yamlEditor.toString())));
  }
}

Future<List<String>> findInnerContent(FileSystemEntity fse) async {
  if (isFilePath(fse.path)) return [fse.path];
  final children = await loadDirectoryFiles(fse.path);
  final pathes = <String>[];
  for (final child in children) {
    if (isFilePath(child.path)) {
      pathes.add(child.path);
    } else {
      final newPathes = await findInnerContent(child);
      pathes.addAll(newPathes);
    }
  }
  return pathes;
}
