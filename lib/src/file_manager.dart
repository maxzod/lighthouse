import 'dart:io';

import 'exceptions/file.dart';

class FilesManager {
  /// give it a file system entity
  /// it will return a list that contains the paths to every single file in that `FileSystemEntity`
  Future<List<String>> findInnerContent(Directory fse) async {
    /// read the directory content
    final children = loadDirectoryFiles(fse.path);

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
  Iterable<FileSystemEntity> loadDirectoryFiles(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) throw DirDoesNotExist(path);
    return dir.listSync();
  }

  /// return list of the directory `json` files
  Iterable<FileSystemEntity> loadDirectoryJsonFiles(String path) {
    final dirFiles = loadDirectoryFiles(path);
    final jsonFiles =
        dirFiles.where((element) => element.path.endsWith('json'));
    if (jsonFiles.isEmpty) throw DirDoesNotContainJsonFiles(path);
    return jsonFiles;
  }
}
