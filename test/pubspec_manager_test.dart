import 'dart:io';

import 'package:lighthouse/src/helpers/yaml.dart';
import 'package:lighthouse/src/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  final fakeYaml = File('assets/pubspec.yaml');
  setUp(() async {
    await fakeYaml.create(recursive: true);
    await fakeYaml.writeAsString(File('pubspec.yaml').readAsStringSync());
  });
  tearDownAll(() async {
    await fakeYaml.delete();
  });
  group(
    'setAssets',
    () {
      test('it add assets to yaml', () async {
        final manger = PubSpecManager();
        await manger.setAssets(['path', 'path2'], fakeYaml);
        final assetsList = await getPubspecAssetsYaml(fakeYaml);
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
}
