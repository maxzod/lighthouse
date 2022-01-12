import 'package:lighthouse/src/commands/assets/add.dart';
import 'package:lighthouse/src/file_manager.dart';
import 'package:lighthouse/src/pubspec_manager.dart';
import 'package:lighthouse/src/mixins.dart';
import 'package:test/test.dart';

void main() {
  final allCommands = <LightHouseCommand>[
    // * Localization
    // generate `Tr` class
    // TRMakeCommand(),
    // validate localizations assets content
    // TrValidateCommand(),

    // * Assets
    // generate assets
    // AssetsMakeCommand(),
    // add assets
    AssetsAddCommand(
        yamlManager: PubSpecManager(), filesManager: FilesManager()),

    /// * pub
    // RemoveUnUsedPackagesCommand(),
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
