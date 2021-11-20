import 'dart:convert';
import 'dart:io';

import 'package:lighthouse/src/exceptions/file/dir_does_not_contain_json.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_exist.dart';
import 'package:lighthouse/src/exceptions/file/dir_is_empty.dart';

Future<List<File>> loadDirectoryFiles(String path) async {
  final dir = Directory(path);
  final dirExist = await dir.exists();
  if (!dirExist) throw DirDoesNotExist(path);
  final dirFiles = dir.listSync();
  if (dirFiles.isEmpty) throw DirIsEmpty(path);
  final jsonFiles = dirFiles.where((element) => element.path.endsWith('json'));
  if (jsonFiles.isEmpty) throw DirDoesNotContainJsonFiles(path);
  return dir.listSync().map((e) => File(e.path)).toList();
}

Future<Map<String, dynamic>> readJsonContent(String path) async {
  final jString = await File(path).readAsString();
  final jsonMap = json.decode(jString);
  return jsonMap;
}
