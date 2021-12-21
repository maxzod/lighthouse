import 'dart:io';

import 'package:yaml/yaml.dart';

Iterable<String> getYamlAssets() {
  final yaml = loadYaml(File('./pubspec.yaml').readAsStringSync());
  return (yaml['flutter']['assets'] as YamlList?)?.map((e) => e.toString()) ??
      [];
}

Iterable<MapEntry> getAppDependencies() {
  final YamlMap? yaml =
      loadYaml(File('./pubspec.yaml').readAsStringSync())['dependencies'];
  return yaml?.entries ?? [];
}

YamlMap getPubspecYaml() {
  final yaml = loadYaml(File('./pubspec.yaml').readAsStringSync());
  return yaml as YamlMap;
}
