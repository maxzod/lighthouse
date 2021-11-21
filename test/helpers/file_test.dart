import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_contain_json.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_exist.dart';
import 'package:lighthouse/src/helpers/file.dart';

void main() {
  final dir = Directory('testdir');
  final file = File('testdir/test.ff');
  setUp(() async {
    if (!dir.existsSync()) {
      await dir.create();
      if (!file.existsSync()) {
        await file.create();
      }
    }
  });

  tearDown(() async {
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  });
  group('loadDirFiles function', () {
    test('should return a list of files', () async {
      final files = await loadDirectoryJsonFiles('./assets/lang');
      expect(files, isNotEmpty);
    });
    test('it throw exception if it does not exist', () async {
      expect(
        () => loadDirectoryJsonFiles('/foo/bar'),
        throwsA(isA<DirDoesNotExist>()),
      );
    });
    test('it throw exception if it does not have any json files', () async {
      expect(
        () => loadDirectoryJsonFiles('testdir'),
        throwsA(isA<DirDoesNotContainJsonFiles>()),
      );
    });
  });

  group('readJsonContent function', () {
    test('should return a json object', () async {
      final json = await readJsonContent('./assets/lang/en.json');
      expect(json, isNotNull);
      expect(json, isNotEmpty);
    });
  });
}
