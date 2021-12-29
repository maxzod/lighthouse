import 'package:args/command_runner.dart';
import 'package:lighthouse/src/commands/assets/add.dart';
import 'package:lighthouse/src/commands/assets/make.dart';
import 'package:lighthouse/src/commands/pub/unused.dart';
import 'package:lighthouse/src/commands/tr/make.dart';
import 'package:lighthouse/src/commands/tr/validate.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

void main() {
  final allCommands = <Command>[
    // * Localization
    // generate `Tr` class
    TRMakeCommand(),
    // validate localizations assets content
    TrValidateCommand(),

    // * Assets
    // generate assets
    AssetsMakeCommand(),
    // add assets
    AssetsAddCommand(),

    /// * pub
    RemoveUnUsedPackagesCommand(),
  ];

  test('all commands names not empty', () {
    expect(allCommands.where((command) => command.name.isEmpty), isEmpty);
  });

  test('all commands description not empty', () {
    expect(
        allCommands.where((command) => command.description.isEmpty), isEmpty);
  });
}
