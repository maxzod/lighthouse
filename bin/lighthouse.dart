import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:lighthouse/lighthouse.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';

Future<void> main(List<String> args) async {
  final get = GetIt.instance;
  get.registerFactory(() => PubSpecManager());
  get.registerFactory(() => FilesManager());

  try {
    final runner =
        CommandRunner('lh, lighthouse', ' ⚡ : CLI For Flutter Queen 👑 .');
    final commands = <Command>[
      // * Localization
      // generate `Tr` class
      //   TRMakeCommand(),
      // validate localizations assets content
      // TrValidateCommand(),

      // * Assets
      // generate assets
      // AssetsMakeCommand(),
      // add assets
      AssetsAddCommand(
        filesManager: GetIt.I.get<FilesManager>(),
        yamlManager: GetIt.I.get<PubSpecManager>(),
      ),

      /// * pub
      // RemoveUnUsedPackagesCommand(),
    ];

    ///  * add commands to the runner
    commands.forEach(runner.addCommand);
    await runner.run(args);
    // } on TrException catch (e) {
    //   print('💡❌:: Can\'t Generate TR File !\n$e');
  } catch (e, st) {
    print(e);
    print(st);
  }
}
