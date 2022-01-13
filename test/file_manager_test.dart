import 'dart:io';

import 'package:lighthouse/src/exceptions/file.dart';
import 'package:lighthouse/src/file_manager.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  final manager = FilesManager();

  group('findInnerContent', () {
    // test('it return the file path alone if is not directory', ()async{

    // final children = await FilesManager().findInnerContent();
    // expect(children, [
    //   'ISSUE_TEMPLATE/bug_report.md',
    //   'ISSUE_TEMPLATE/feature_request.md',
    //   'workflows/dart.yml',
    // ]);
  });

  group(
    'removeUnNecessaryChildren',
    () {
      test('it return [] if list is empty', () async {
        expect(
          await FilesManager().removeUnNecessaryChildren([]),
          [],
        );
      });
      test('it remove children if parent is in the list', () async {
        expect(
          await FilesManager().removeUnNecessaryChildren([
            'foo/',
            'test/assets/foo.png',
            'test/assets/bar.png',
            'test/assets/images/lighthouse.png',
            'test/assets/images/home/i1_home.png',
            'test/assets/images/home/i2_home.png',
            'test/assets/audio/quran/surah_1.mp3',
            'test/assets/audio/quran/surah_2.mp3',
            'test/assets/audio/quran/elhosary/surah_1.mp3',
          ]),
          [
            'foo/',
            'test/assets/',
            'test/assets/images/',
            'test/assets/images/home/',
            'test/assets/audio/quran/',
            'test/assets/audio/quran/elhosary/',
          ],
        );
      });
      test('it skips hidden files or directories', () async {
        expect(
          await FilesManager().removeUnNecessaryChildren([
            'test/assets/.secrets/.gitignore',
            'test/assets/.secrets/.DS_Store',
            'test/assets/.assets/foo.png',
            'test/assets/',
            'test/assets/images/lighthouse.png',
            'test/assets/images/home/i1_home.png',
            'test/assets/images/home/i2_home.png',
            'test/assets/audio/quran/surah_1.mp3',
            'test/assets/audio/quran/surah_2.mp3',
            'test/assets/audio/quran/elhosary/surah_1.mp3',
          ]),
          [
            'test/assets/',
            'test/assets/images/',
            'test/assets/images/home/',
            'test/assets/audio/quran/',
            'test/assets/audio/quran/elhosary/',
          ],
        );
      });
    },
  );

  group(
    'loadDirectoryJsonFiles function',
    () {
      test(
        'should return a list of files',
        () async {
          final files = FilesManager()
              .loadDirectoryJsonFiles(Directory('test/assets/lang'));
          expect(files, isNotEmpty);
        },
      );
      test(
        'it throw exception if it does not exist',
        () async {
          expect(
            () => FilesManager().loadDirectoryJsonFiles(Directory('foo/bar')),
            throwsA(isA<DirDoesNotExist>()),
          );
        },
      );
      test(
        'it throw exception if it does not have any json files',
        () async {
          expect(
            () => FilesManager()
                .loadDirectoryJsonFiles(Directory('test/assets/images/foo')),
            throwsA(isA<DirDoesNotContainJsonFiles>()),
          );
        },
      );
    },
  );

  group(
    'loadDirectoryFiles function',
    () {
      test(
        'it can load directory files',
        () async {
          final files =
              FilesManager().loadDirectoryFiles(Directory('test/assets/lang'));
          // final paths = files.map((f) => f.path).toList();
          final paths = files
              .map((f) =>
                  f.path.replaceAll('\\', '/').replaceAll('/', separator))
              .toList();
          expect(paths.length, 2);
          expect(
              paths,
              containsAll([
                'test${separator}assets${separator}lang${separator}ar.json',
                'test${separator}assets${separator}lang${separator}en.json',
              ]));
        },
      );
      test(
        'if path is not valid directory it throws DirDoesNotExist',
        () {
          expect(
            () =>
                FilesManager().loadDirectoryFiles(Directory('bad\\dir\\path')),
            throwsA(isA<DirDoesNotExist>()),
          );
        },
      );
    },
  );
  group(
    'readJsonContent function',
    () {
      test(
        'should return a json object',
        () async {
          final json = await FilesManager()
              .readJsonContent(File('test/assets/lang/en.json'));
          expect(json, isNotNull);
          expect(json, isNotEmpty);
        },
      );
      test(
        'throw FileDoesNotExist if there is no file',
        () {
          expect(
            () => FilesManager().readJsonContent(File('404/en.json')),
            throwsA(isA<FileDoesNotExist>()),
          );
        },
      );
    },
  );

  group(
    'isParentDir',
    () {
      test(
        'should return true if is the same path',
        () async {
          expect(
              manager.isEnoughToUseParent(
                  'assets/lang/foo.bar', 'assets\\lang\\foo.bar'),
              isTrue);
        },
      );
      test(
        'should return true if it is the parent dir',
        () async {
          expect(
              manager.isEnoughToUseParent(
                  'assets/lang/', 'assets${separator}lang${separator}ar.json'),
              isTrue);
        },
      );
      test(
        'it will return false if is not direct parent',
        () {
          expect(
              manager.isEnoughToUseParent(
                  'assets/lang/', 'assets\\lang\\foo\\en.json'),
              isFalse);
        },
      );
      test(
        'should return false if it is not a parent dir',
        () async {
          expect(
              manager.isEnoughToUseParent(
                  './assets/ang/en.json', '.\\assets\\lang\\foo\\en.json'),
              isFalse);
        },
      );
    },
  );

  group(
    'isFilePath',
    () {
      test(
        'it return true if is file path',
        () async {
          expect(await FilesManager().isFilePath('test/assets/lang/en.json'),
              isTrue);
        },
      );
      test(
        'it return false if is not a file path',
        () async {
          expect(await FilesManager().isFilePath('test/assets/lang'), isFalse);
        },
      );
    },
  );
  group(
    'findFileName',
    () {
      test('it extracts file name with extension', () {
        expect(
            manager
                .findFileName('test/assets${separator}lang${separator}en.json'),
            'en.json');
      });
      test(
        'it throws exception if the path does not contains any separators',
        () {
          expect(
            () => manager.findFileName('path-without-any-separators.png'),
            throwsA(isA<Exception>()),
          );
        },
      );
    },
  );
  group('findFileExtension', () {
    test('it extracts file extension', () {
      expect(
        manager.findFileExtension(
            'test/assets${separator}lang${separator}en.json'),
        'json',
      );
    });
    test(
      'it throws exception if the path does not contains any separators',
      () {
        expect(
          () => manager.findFileExtension('path-without-any-dots-png'),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
