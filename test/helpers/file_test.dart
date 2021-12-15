import 'dart:io';

import 'package:test/test.dart';
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

  group('isParentDir', () {
    test('should return true if is the same path', () async {
      expect(
          isParentDir('assets/lang/foo.bar', 'assets\\lang\\foo.bar'), isTrue);
    });
    test('should return true if it is the parent dir', () async {
      expect(isParentDir('assets/lang/', 'assets\\lang\\ar.json'), isTrue);
    });
    test('it will return false if is not direct parent', () {
      expect(
          isParentDir('assets/lang/', 'assets\\lang\\foo\\en.json'), isFalse);
    });
    test('should return false if it is not a parent dir', () async {
      expect(
          isParentDir('./assets/ang/en.json', '.\\assets\\lang\\foo\\en.json'),
          isFalse);
    });
  });
}
