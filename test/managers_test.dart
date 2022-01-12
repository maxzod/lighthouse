import 'package:lighthouse/src/managers.dart';
import 'package:test/test.dart';

void main() {
  group(
    'PubspecManager',
    () {
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
    },
  );
  group(
    'FilesManager',
    () {
      group(
        'removeUnNecessaryChildren',
        () {
          test('it return [] if list is empty', () {
            expect(
              FilesManager().removeUnNecessaryChildren([]),
              [],
            );
          });
          test('it remove children if parent is in the list', () {
            expect(
              FilesManager().removeUnNecessaryChildren([
                'foo/',
                'assets/foo.png',
                'assets/bar.png',
                'assets/images/lighthouse.png',
                'assets/images/home/i1_home.png',
                'assets/images/home/i2_home.png',
                'assets/audio/quran/surah_1.mp3',
                'assets/audio/quran/surah_2.mp3',
                'assets/audio/quran/elhosary/surah_1.mp3',
              ]),
              [
                'foo/',
                'assets/',
                'assets/images/',
                'assets/images/home/',
                'assets/audio/quran/',
                'assets/audio/quran/elhosary/',
              ],
            );
          });
          test('it skips hidden files or directories', () {
            expect(
              FilesManager().removeUnNecessaryChildren([
                '.secrets/.gitignore',
                '.secrets/.DS_Store',
                '.assets/foo.png',
                'assets/images/lighthouse.png',
                'assets/images/home/i1_home.png',
                'assets/images/home/i2_home.png',
                'assets/audio/quran/surah_1.mp3',
                'assets/audio/quran/surah_2.mp3',
                'assets/audio/quran/elhosary/surah_1.mp3',
              ]),
              [
                'assets/images/',
                'assets/images/home/',
                'assets/audio/quran/',
                'assets/audio/quran/elhosary/',
              ],
            );
          });
        },
      );
    },
  );
}
