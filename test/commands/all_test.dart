import 'package:lighthouse/src/commands/assets/add.dart';
import 'package:lighthouse/src/commands/assets/make.dart';
import 'package:lighthouse/src/commands/pub/unused.dart';
import 'package:lighthouse/src/commands/tr/make.dart';
import 'package:lighthouse/src/commands/tr/validate.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
import 'package:lighthouse/src/managers/recase.dart';
import 'package:lighthouse/src/mixins.dart';
import 'package:test/test.dart';

void main() {
  final allCommands = <LightHouseCommand>[
    // * Localization
    // generate `Tr` class
    TRMakeCommand(
      yamlManager: PubSpecManager(),
      filesManager: FilesManager(),
    ),
    // validate localizations assets content
    TrValidateCommand(
      yamlManager: PubSpecManager(),
      filesManager: FilesManager(),
    ),

    // * Assets
    // generate assets
    AssetsMakeCommand(
      yamlManager: PubSpecManager(),
      filesManager: FilesManager(),
      recaseManager: RecaseManager(),
    ),
    // add assets
    AssetsAddCommand(
      yamlManager: PubSpecManager(),
      filesManager: FilesManager(),
    ),

    /// * pub
    RemoveUnUsedPackagesCommand(
      filesManager: FilesManager(),
      pubSpecManager: PubSpecManager(),
    ),
  ];

  test('all commands names not empty', () {
    expect(allCommands.where((command) => command.name.isEmpty), isEmpty);
  });

  test('all commands description not empty', () {
    expect(
        allCommands.where((command) => command.description.isEmpty), isEmpty);
  });
  test('all commands success message', () {
    expect(allCommands.where((command) => command.successMessage.isEmpty),
        isEmpty);
  });
}
