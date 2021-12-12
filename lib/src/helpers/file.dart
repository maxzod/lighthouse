import 'dart:convert';
import 'dart:io';

import 'package:lighthouse/src/exceptions/file/dir_does_not_contain_json.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_exist.dart';
import 'package:lighthouse/src/exceptions/file/dir_is_empty.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';

Future<List<FileSystemEntity>> loadDirectoryJsonFiles(String path) async {
  final dirFiles = await loadDirectoryFiles(path);
  if (dirFiles.isEmpty) throw DirIsEmpty(path);
  final jsonFiles = dirFiles.where((element) => element.path.endsWith('json'));
  if (jsonFiles.isEmpty) throw DirDoesNotContainJsonFiles(path);
  return jsonFiles.toList();
}

Future<List<FileSystemEntity>> loadDirectoryFiles(String path) async {
  final dir = Directory(path);
  final dirExist = await dir.exists();
  if (!dirExist) throw DirDoesNotExist(path);
  final dirFiles = dir.listSync();
  if (dirFiles.isEmpty) throw DirIsEmpty(path);

  return dir.listSync();
}

Future<Map<String, dynamic>> readJsonContent(String path) async {
  final jString = await File(path).readAsString();
  final jsonMap = json.decode(jString);
  return jsonMap;
}

bool isParentDir(String parent, String child) {
  final parentParts = parent.split('/')..removeWhere((e) => e.isEmpty);
  final childParts = child.split(path.separator)..removeWhere((e) => e.isEmpty);
  final childCount = childParts.length;
  final parentCount = parentParts.length;
  // final parentReplaced = parent.replaceAll('\\', '/');
  final isTheSame = parent == child.replaceAll('\\', '/');
  return isTheSame ||
      ((parentCount + 1 == childCount) &&
          child.startsWith(parent.replaceAll('/', path.separator)));
}

bool isFilePath(String path) {
  return path.split(separator).last.contains('.');
}

/// return the file name with the extension
String findFileName(String path) => path.split(separator).last;

/// return the file  extension
/// foo.mp3 => mp3
String findFileExtension(String path) => path.split('.').last;

/// *  load the locale from json files
/// * why null ? because the file might be corrupted some how or missing a comma in the end !
Future<Map<String, dynamic>?> loadJsonFileContent(String path) async {
  // try {
  //   // *  parse it to string
  //   return json.decode(
  //     /// *  load content
  //     await rootBundle.loadString(path),
  //   ) as Map<String, dynamic>?;
  // } catch (_) {
  //   return null;
  // }
}
