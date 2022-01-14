import 'dart:io';

import 'package:lighthouse/src/commands/pub/unused.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
import 'package:test/test.dart';

class FakeRemoveUnUsedPackagesCommand extends RemoveUnUsedPackagesCommand {
  FakeRemoveUnUsedPackagesCommand()
      : super(filesManager: FilesManager(), pubSpecManager: PubSpecManager());

  @override
  String get pubspecPath => 'test/assets/pubspec.yaml';

  @override
  String get filesDir => 'test/assets/lib';
}

void main() {
  final fakeYaml = File('test/assets/pubspec.yaml');
  setUp(() async {
    await fakeYaml.create(recursive: true);
    await fakeYaml.writeAsString(
        File('test/assets/pubspec_fort_test.yaml').readAsStringSync());
  });
  tearDownAll(() async {
    await fakeYaml.delete();
  });
  test('it run no errors', () async {
    await FakeRemoveUnUsedPackagesCommand().run();

    final afterDependencies = await PubSpecManager().findUsedPackages(fakeYaml);
    expect(afterDependencies.length, 6);

    for (final package in [
      'nations_assets',
      'readable',
      'get_it',
      'meta',
    ]) {
      expect(afterDependencies.contains(package), isFalse);
    }
  });
  test('it have the right paths', () {
    final manager = RemoveUnUsedPackagesCommand(
      filesManager: FilesManager(),
      pubSpecManager: PubSpecManager(),
    );
    expect(manager.pubspecPath, 'pubspec.yaml');
    expect(manager.filesDir, 'lib');
  });
}
