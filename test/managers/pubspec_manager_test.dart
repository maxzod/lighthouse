import 'dart:io';

import 'package:lighthouse/src/exceptions/file.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
import 'package:path/path.dart' hide equals;
import 'package:test/test.dart';

void main() {
  final fakeYaml = File('test/assets/pubspec.yaml');
  final emptyDir = Directory('test/assets/empty');
  setUp(() async {
    await fakeYaml.create(recursive: true);
    await fakeYaml.writeAsString(
        File('test/assets/pubspec_fort_test.yaml').readAsStringSync());
    await emptyDir.create(recursive: true);
  });
  tearDownAll(() async {
    await fakeYaml.delete();
    await emptyDir.delete();
  });
  group('getYamlAssets function', () {
    test('it should return flutter.assets content from pubspec.yaml', () async {
      final assets = await PubSpecManager()
          .getYamlAssets(File('test/assets/pubspec.yaml'));
      expect(assets.isNotEmpty, isTrue);
      expect(
          assets,
          equals([
            'assets/foo.png',
            'assets/bar.png',
          ]));
    });
    test('it return  empty list if there is not assets', () async {
      final assets = await PubSpecManager()
          .getYamlAssets(File('test/assets/pubspec_without_assets.yaml'));
      expect(assets.isEmpty, isTrue);
      expect(assets, equals([]));
    });
  });
  group(
    'setAssets',
    () {
      test('it add assets to yaml', () async {
        final manger = PubSpecManager();
        await manger.setAssets(['path', 'path2'], fakeYaml);
        final assetsList = await manger.getYamlAssets(fakeYaml);
        expect(
          assetsList,
          ['path', 'path2'],
        );
      });
    },
  );

  group(
    'formatPaths',
    () {
      test(
        'if list is empty it return empty list',
        () {
          expect(PubSpecManager().formatPaths([]), []);
        },
      );
      test(
        'it removes `./` in the begging',
        () {
          expect(
            PubSpecManager().formatPaths(
              [
                './assets/images/lighthouse.dart',
                './foo/bar/zee.dart',
                '',
              ],
            ),
            [
              'assets/images/lighthouse.dart',
              'foo/bar/zee.dart',
              '',
            ],
          );
        },
      );
      test(
        'it replaces `\\` separators with /',
        () {
          expect(
            PubSpecManager().formatPaths([
              '.\\assets\\images\\lighthouse.dart',
              '.\\foo\\bar\\zee.dart',
            ]),
            [
              'assets/images/lighthouse.dart',
              'foo/bar/zee.dart',
            ],
          );
        },
      );
    },
  );
  group('isInYamlAssets', () {
    test('it return false if assets is empty', () {
      expect(PubSpecManager().isInYamlAssets('', []), isFalse);
    });

    test(
      'it returns true if the path is in the assets list',
      () {
        expect(
          PubSpecManager().isInYamlAssets(
            'assets/images/lighthouse.dart',
            [
              'assets/images/lighthouse.dart',
            ],
          ),
          isTrue,
        );
      },
    );
    test(
      'it returns true if parent path is in the assets list',
      () {
        expect(
          PubSpecManager().isInYamlAssets(
            'assets/images/lighthouse.dart',
            [
              'assets/images/',
            ],
          ),
          isTrue,
        );
      },
    );
    test(
      'it formats the path before checking',
      () {
        expect(
          PubSpecManager().isInYamlAssets(
            // windows path
            'assets\\images\\lighthouse.dart',
            [
              'assets/images/',
            ],
          ),
          isTrue,
        );
      },
    );
  });
  group(
    'getPubspecDependencies',
    () {
      test(
        'it will return the dependencies from the yaml file',
        () {
          final data = PubSpecManager().getPubspecDependencies(
            File('test/assets/pubspec_fort_test.yaml'),
          );
          expect(data.isNotEmpty, isTrue);
          expect(data.map((e) => e.key), [
            'path',
            'df_builder',
            'args',
            'yaml',
            'recase',
            'nations_assets',
            'yaml_edit',
            'readable',
            'get_it',
            'meta',
          ]);
        },
      );
    },
  );
  group('girDirectoryChildrenFlat', () {
    final manager = FilesManager();
    test('it return empty list if the directory is empty', () async {
      expect(
        await manager.girDirectoryChildrenFlat(Directory('test/assets/empty')),
        isEmpty,
      );
    });
    test('it return directory files', () async {
      final data = (await manager
              .girDirectoryChildrenFlat(Directory('test/assets/lang')))
          .map((e) => e.path);

      expect(data.length, 2);
      expect(data.contains('test/assets/lang${separator}ar.json'), isTrue);
      expect(data.contains('test/assets/lang${separator}en.json'), isTrue);
    });
    test('it loads the children too', () async {
      final data = (await manager
              .girDirectoryChildrenFlat(Directory('test/assets/audio')))
          .map((e) => e.path);

      expect(data.length, 2);
      expect(
          data.contains(
              'test/assets/audio${separator}music${separator}sound.mp3'),
          isTrue);
      expect(
          data.contains(
              'test/assets/audio${separator}quran${separator}sound.mp3'),
          isTrue);
    });
  });

  group('findUsedPackages', () {
    test('it return empty list if there is no unused packages', () async {
      final data = await PubSpecManager().findUsedPackages(
        File('test/assets/pubspec_fort_test.yaml'),
      );
      expect(
        data,
        containsAll(
          [
            'path',
            'df_builder',
            'args',
            'yaml',
            'recase',
            'nations_assets',
            'yaml_edit',
            'readable',
            'get_it',
            'meta',
          ],
        ),
      );
    });
  });
  group('findUnUsedPackages', () {
    test('it return empty list if there is no unused packages', () async {
      final data = await PubSpecManager().findUnUsedPackages(
        File('test/assets/no_deps.yaml'),
        Directory('test/assets/lib'),
      );
      expect(data.isEmpty, isTrue);
    });
    test('it return empty list if there is no unused packages', () async {
      final data = await PubSpecManager().findUnUsedPackages(
        File('test/assets/pubspec_fort_test.yaml'),
        Directory('test/assets/lib'),
      );
      expect(data.length, 4);
      expect(
        data,
        containsAll(['nations_assets', 'readable', 'get_it', 'meta']),
      );
    });
  });

  group('removeDependencies', () {
    test('it throws if file does not exist', () {
      expect(
        () => PubSpecManager().removeDependencies(File('test/-foo-bar'), []),
        throwsA(isA<FileDoesNotExist>()),
      );
    });
    test('it removes dependencies', () async {
      await PubSpecManager().removeDependencies(
        fakeYaml,
        ['path', 'df_builder', 'args', 'yaml', 'recase'],
      );
      final afterDependencies =
          await PubSpecManager().findUsedPackages(fakeYaml);
      expect(afterDependencies.length, 5);
      for (final package in ['path', 'df_builder', 'args', 'yaml', 'recase']) {
        expect(afterDependencies.contains(package), isFalse);
      }
    });
  });
}
