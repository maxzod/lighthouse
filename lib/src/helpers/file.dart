import 'dart:io';

import 'package:lighthouse/src/exceptions/file.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';

/// return list of the directory `json` files
Iterable<FileSystemEntity> loadDirectoryJsonFiles(String path) {
  final dirFiles = loadDirectoryFiles(path);
  final jsonFiles = dirFiles.where((element) => element.path.endsWith('json'));
  if (jsonFiles.isEmpty) throw DirDoesNotContainJsonFiles(path);
  return jsonFiles;
}

/// list  directory files
// Future<Iterable<FileSystemEntity>> loadDirectoryFiles(String path) async {
//   final dir = Directory(path);
//   if (!await dir.exists()) throw DirDoesNotExist(path);
//   return dir.listSync();
// }

Iterable<FileSystemEntity> loadDirectoryFiles(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) throw DirDoesNotExist(path);
  return dir.listSync();
}

// /// list  directory files
// Future<Iterable<FileSystemEntity>> loadAssetsFiles() async {
//   final dir = Directory('./assets');
//   if (!await dir.exists()) throw DirDoesNotExist('./assets');
//   return dir.listSync();
// }

/// return content of json file based on the path
// Future<Map<String, dynamic>> readJsonContent(String path) async {
//   try {
//     final jString = await readFileContent(path);
//     return json.decode(jString);
//   } on FormatException {
//     throw '$path file is not valid json';
//   }
// }

/// return content of json file based on the path
// Future<String> readFileContent(String path) async {
//   final file = File(path);
//   if (!await file.exists()) throw FileDoesNotExist(path);
//   return file.readAsString();
// }

/// return true if the parent is enough for flutter to use the the child
/// like when enter `foo/` and `foo/bar.png`  flutter can use `foo/bar.png`
/// if `foo/` is in flutter assets in `pubspec.yaml`
bool isEnoughToUseParent(String parent, String child) {
  final parentParts = parent.split('/')..removeWhere((e) => e.isEmpty);
  final childParts = child.split(path.separator)..removeWhere((e) => e.isEmpty);
  final childCount = childParts.length;
  final parentCount = parentParts.length;
  final isTheSame = parent == child.replaceAll('\\', '/');
  return isTheSame ||
      ((parentCount + 1 == childCount) &&
          child.startsWith(parent.replaceAll('/', path.separator)));
}

/// return `true` if the path ends with `extension`
/// cat till for sure if file without extension unless perform `io` logic
/// and we don't need it for simplicity
bool isFilePath(String path) => path.split(separator).last.contains('.');

/// return the file name with the extension
/// ! throw `Exception` if the path does not contains a separator
String findFileName(String path) {
  if (path.contains(separator)) {
    return path.split(separator).last;
  } else {
    throw Exception('path is not valid it does not contains separator');
  }
}

/// return the file  extension
/// foo.mp3 => mp3
String findFileExtension(String path) {
  if (path.contains('.')) {
    return path.split('.').last;
  } else {
    throw Exception('path is not valid it does not contains .');
  }
}

// /// *  load the locale from json files
// /// * why null ? because the file might be corrupted some how or missing a comma in the end !
// Future<Map<String, dynamic>?> loadJsonFileContent(String path) async {}

// /// *  return supported locales based on files names
// List<String> findSupportedLocales(Iterable<FileSystemEntity> files) {
//   return files
//       .map((f) => f.path.split('/').last.replaceAll('.json', ''))
//       .toList();
// }

// Future<List<File>> girDirectoryChildrenFlat(String root) async {
//   final files = <File>[];
//   final children = await loadDirectoryFiles(root);

//   for (final child in children) {
//     if (child is File) {
//       files.add(File(child.path));
//     } else {
//       files.addAll(await girDirectoryChildrenFlat(child.path));
//     }
//   }
//   return files;
// }
