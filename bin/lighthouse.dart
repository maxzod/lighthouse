import 'package:args/command_runner.dart';
import 'package:lighthouse/src/commands/assets/add.dart';
import 'package:lighthouse/src/commands/assets/make.dart';
import 'package:lighthouse/src/commands/tr/make.dart';
import 'package:lighthouse/src/commands/tr/validate.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';

Future<void> main(List<String> args) async {
  try {
    final runner =
        CommandRunner('lh, lighthouse', ' ⚡ : CLI For Flutter Queen 👑 .');

    // * Localization
    // * generate TR class
    runner.addCommand(TRMakeCommand());
    //  * validate localizations assets content
    runner.addCommand(TrValidateCommand());

    // * Assets
    // * generate assets
    runner.addCommand(AssetsMakeCommand());
    // * add assets
    runner.addCommand(AssetsAddCommand());

    await runner.run(args);
  } on TrException catch (e) {
    print('💡❌:: Can\'t Generate TR File !\n$e');
  } catch (e, st) {
    print(st);
    print(e.toString());
  }
}
