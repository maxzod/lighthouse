import 'dart:convert';
import 'dart:io';

import 'package:lighthouse/src/exceptions/dir_does_not_exist.dart';
import 'package:lighthouse/src/exceptions/dir_is_empty.dart';
import 'package:lighthouse/src/exceptions/message.dart';

Future<List<File>> loadDirectoryFiles(String path) async {
  final dir = Directory(path);
  final dirExist = await dir.exists();
  if (!dirExist) throw DirDoesNotExist(path);
  final dirFiles = dir.listSync();
  if (dirFiles.isEmpty) throw DirIsEmpty(path);
  final jsonFiles = dirFiles.where((element) => element.path.endsWith('json'));
  if (jsonFiles.isEmpty) {
    throw MessageException('dir "$path" does not have any json Files');
  }

  ///* validate all json files is locle named
  // TODO :: validation
  // for (final file in jsonFiles) {
  //   final fileName = file.path.split('/').last;
  //   if (fileName.length != 5 || fileName.length != 2) {
  //     throw MessageException('''
  //         file ${file.path} name is not valid it must be in this speceifc format
  //         Example 1 : LocaleCode.json => ar , en , fr
  //         Example 2 : LocaleCode_CounteryCode => ar_EG en_US ,
  //         ''');
  //   } else if (fileName.length == 2) {
  //     // build for
  //   }
  // }

  // final cotnent =

  return [];
}

Future<Map<String, dynamic>> readJsonContent(String path) async {
  final jString = await File(path).readAsString();
  final jsonMap = json.decode(jString);
  return jsonMap;
}
