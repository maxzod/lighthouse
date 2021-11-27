import 'dart:io';
import '../../../bin/lighthouse.dart' as lh;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('assets:make command', () {
    final assetsFile = File('lib/generated/assets.dart');
    setUp(() {
      /// *
      if (assetsFile.existsSync()) {
        assetsFile.deleteSync();
      }
    });

    tearDown(() {
      if (assetsFile.existsSync()) {
        assetsFile.deleteSync();
      }
    });

    test(
        'it mark assets as deprecated if is not in the assets tag in pubspec.yaml',
        () async {
      await lh.main(['assets:make']);
      final content = assetsFile.readAsStringSync();
      expect(
        content.contains(
            'assets/audio/music/sound.mp3 is not in your assets in pubspec.yaml'),
        isTrue,
        reason: 'it is not in the yaml file',
      );
    });
    test(
        'it does not mark assets  as deprecated if they are in the assets tag in pubspec.yaml',
        () async {
      await lh.main(['assets:make']);
      final content = assetsFile.readAsStringSync();
      expect(
        content.contains(
            'assets/camera.png is not in your assets in pubspec.yaml'),
        isFalse,
        reason: 'it is not in the yaml file',
      );
    });
  });
}
