import 'package:lighthouse/lighthouse.dart';
import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:lighthouse/src/managers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'add_test.mocks.dart';

@GenerateMocks([FilesManager, PubSpecManager])
void main() {
  test(
    'it have a description',
    () => expect(
      AssetsAddCommand(
              filesManager: FilesManager(), yamlManager: PubSpecManager())
          .description,
      isNotEmpty,
    ),
  );
  test(
    'it have a name',
    () => expect(
        AssetsAddCommand(
          filesManager: FilesManager(),
          yamlManager: PubSpecManager(),
        ).name,
        isNotEmpty),
  );
  test('it throws if asset directory is empty', () async {
    final fManager = MockFilesManager();

    when(fManager.dirChildren(any)).thenAnswer((_) => []);
    Object? exception;
    try {
      await AssetsAddCommand(
        filesManager: fManager,
        yamlManager: PubSpecManager(),
      ).run();
    } catch (e) {
      exception = e;
    }
    expect(exception, isA<NoAssetsException>());
  });
  test('it runs without errors', () async {
    final fManager = MockFilesManager();
    final pubspec = MockPubSpecManager();
    when(fManager.dirChildren(any)).thenAnswer((_) => ['', '', '']);
    await AssetsAddCommand(
      filesManager: fManager,
      yamlManager: pubspec,
    ).run();
    expect(pubspec, isA<NoAssetsException>());
  });
}
