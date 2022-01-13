import 'dart:convert';
import 'dart:io';

import 'exceptions/file.dart';
import 'package:path/path.dart';

class FilesManager {
  /// give it a file system entity
  /// it will return a list that contains the paths to every single file in that `FileSystemEntity`
  Future<List<String>> findInnerContent(Directory dir) async {
    /// read the directory content
    final children = loadDirectoryFiles(dir);

    /// to contains the children of this Directory
    final childrenPaths = <String>[];
    for (final child in children) {
      /// if this is a file add the path to the children's list
      if (await isDirPath(child.path)) {
        /// recursive call to find the children of this children
        final newPaths = await findInnerContent(child as Directory);
        childrenPaths.addAll(newPaths);
      } else {
        childrenPaths.add(child.path);
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
  Future<List<String>> removeUnNecessaryChildren(List<String> list) async {
    List<String> holder = [];
    for (final path in list) {
      if (path.split('/').any((element) => element.startsWith('.'))) continue;

      if (await isDirPath(path)) {
        holder.add(path.endsWith('/') ? path : '$path/');
      } else {
        //  remove the file and leave the rest

        final newPath = path.split('/');
        newPath.removeLast();
        holder.add('${newPath.join('/')}/');
      }
    }
    return holder.toSet().toList();
  }

  /// return `true` if file path
  /// return 'false` if is directory or the path does not exist
  Future<bool> isFilePath(String path) => FileSystemEntity.isFile(path);
//  path.split(separator).last.contains('.');

  /// return `true` if directory path
  /// return 'false` if is directory does not exist of the path is for file
  Future<bool> isDirPath(String path) => FileSystemEntity.isDirectory(path);
//  path.split(separator).last.contains('.');
  Iterable<FileSystemEntity> loadDirectoryFiles(Directory directory) {
    if (!directory.existsSync()) throw DirDoesNotExist(directory.path);
    return directory.listSync();
  }

  /// return list of the directory `json` files
  Iterable<FileSystemEntity> loadDirectoryJsonFiles(Directory directory) {
    final dirFiles = loadDirectoryFiles(directory);
    final jsonFiles =
        dirFiles.where((element) => element.path.endsWith('json'));
    if (jsonFiles.isEmpty) throw DirDoesNotContainJsonFiles(directory.path);
    return jsonFiles;
  }

  /// return content of json file based on the path
  Future<Map<String, dynamic>> readJsonContent(File file) async {
    final jString = await readFileContent(file);
    return json.decode(jString);
  }

  /// return content of json file based on the path
  Future<String> readFileContent(File file) async {
    if (!await file.exists()) throw FileDoesNotExist(file.path);
    return file.readAsString();
  }

  /// return true if the parent is enough for flutter to use the the child
  /// like when enter `foo/` and `foo/bar.png`  flutter can use `foo/bar.png`
  /// if `foo/` is in flutter assets in `pubspec.yaml`
  bool isEnoughToUseParent(String parent, String child) {
    // for windows
    String c = child.replaceAll('\\', '/');
    String p = parent.replaceAll('\\', '/');
    // they are the same path
    if (c == p) return true;
    final cParts = c.split('/')..removeWhere((element) => element.isEmpty);
    final pParts = p.split('/')..removeWhere((element) => element.isEmpty);
    if (cParts.length != pParts.length + 1) {
      /// the child is too deep that the parent can not be enough for flutter
      /// example
      /// the child is foo/bar/baz.png
      /// and the parent is foo/
      return false;
    }

    cParts.removeLast();
    // TODO :: why cParts == pParts will return false and if the are joined it will return true
    return cParts.join('/') == pParts.join('/');
  }

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

//

  /// *  return supported locales based on files names
  List<String> findSupportedLocales(Iterable<FileSystemEntity> files) {
    return files
        .map((f) => f.path.split('/').last.replaceAll('.json', ''))
        .toList();
  }

  Future<List<File>> girDirectoryChildrenFlat(Directory directory) async {
    final files = <File>[];
    final children = loadDirectoryFiles(directory);

    for (final child in children) {
      if (child is File) {
        files.add(File(child.path));
      } else {
        files.addAll(await girDirectoryChildrenFlat(child as Directory));
      }
    }
    return files;
  }
}
