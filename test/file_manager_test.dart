import 'package:lighthouse/src/file_manager.dart';
import 'package:test/test.dart';

void main() {
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
}
