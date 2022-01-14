import 'package:lighthouse/lighthouse.dart';
import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
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

    when(fManager.findInnerContent(any)).thenAnswer((_) async => []);
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
    final mockFManager = MockFilesManager();
    final mockPubspec = MockPubSpecManager();
    when(mockFManager.findInnerContent(any))
        .thenAnswer((_) async => ['', '', '']);
    when(mockFManager.removeUnNecessaryChildren(any))
        .thenAnswer((_) async => []);
    when(mockPubspec.setAssets(any, any)).thenAnswer((_) async {});
    await AssetsAddCommand(
      filesManager: mockFManager,
      yamlManager: mockPubspec,
    ).run();
  });
}
