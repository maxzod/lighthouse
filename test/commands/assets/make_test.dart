import 'dart:io';

import 'package:lighthouse/src/commands/assets/make.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
import 'package:lighthouse/src/managers/recase.dart';

import 'package:path/path.dart';
import 'package:test/test.dart';

class FakeAssetsMakeCommand extends AssetsMakeCommand {
  FakeAssetsMakeCommand({
    required PubSpecManager yamlManager,
    required FilesManager filesManager,
    required RecaseManager recaseManager,
  }) : super(
          filesManager: filesManager,
          recaseManager: recaseManager,
          yamlManager: yamlManager,
        );

  @override
  String get outputPath => 'test/generated/assets.dart';

  @override
  String get pubspecPath => 'test/assets/pubspec_fort_test.yaml';

  @override
  String get assetsPath => 'test/assets';
}

void main() {
  final command = FakeAssetsMakeCommand(
    filesManager: FilesManager(),
    recaseManager: RecaseManager(),
    yamlManager: PubSpecManager(),
  );
  group('assets:make command', () {
    final assetsFile = File(command.outputPath);

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

    test('it have the right paths', () {
      final manager = AssetsMakeCommand(
        filesManager: FilesManager(),
        recaseManager: RecaseManager(),
        yamlManager: PubSpecManager(),
      );
      expect(manager.outputPath, 'lib/generated/assets.dart');
      expect(manager.pubspecPath, 'pubspec.yaml');
      expect(manager.assetsPath, 'assets');
      expect(manager.rootName, 'Assets');
    });
    test(
        'it mark assets as deprecated if is not in the assets tag in pubspec.yaml',
        () async {
      await command.run();
      final content = assetsFile.readAsStringSync();
      expect(
        content.contains(
            'assets/audio/music/sound.mp3 is not in your assets in pubspec.yaml'),
        isTrue,
        reason: 'it is not in the yaml file',
      );
    });
    test(
        'it does not mark assets as deprecated if  are in the assets tag in pubspec.yaml',
        () async {
      await command.run();
      final content = assetsFile.readAsStringSync();
      expect(
        content.contains(
            'assets/camera.png is not in your assets in pubspec.yaml'),
        isTrue,
        reason: 'it is not in the yaml file',
      );
    });

    test('Must skip files that starts with dot', () async {
      await command.run();
      final content = assetsFile.readAsStringSync();
      expect(
        content.contains('.hidden'),
        isFalse,
        reason:
            'files starts with dot can not have name and its not set by user , in macos many folders contains .DS_Store file',
      );
    });
  });

  group('findFSTypeComment', () {
    test(
      'if dir path it will return comment of dir',
      () async {
        final comment = await command.findFSTypeComment('test/assets', []);
        expect(comment, '/// * Directory');
      },
    );
    test(
      'if the fire is not in assets wt will mark it as deprecated',
      () async {
        final comment = await command.findFSTypeComment(
          'test{$separator}assets{$separator}foo.png',
          [],
        );
        expect(comment.contains('@Deprecated'), isTrue);
      },
    );
  });
}
