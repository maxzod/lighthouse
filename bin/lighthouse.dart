import 'package:args/command_runner.dart';
import 'package:lighthouse/src/commands/assets/make.dart';
import 'package:lighthouse/src/commands/init.dart';
import 'package:lighthouse/src/commands/tr/make.dart';
import 'package:lighthouse/src/exceptions/tr/tr_exception.dart';

Future<void> main(List<String> args) async {
  // await AssetsMakeCommand().run();
  // return;
  try {
    final runner =
        CommandRunner('lh, lighthouse', ' ⚡ : CLI For Flutter Queen 👑 .');

    /// * create new project with queen structure
    runner.addCommand(Init());

    /// * generate TR class
    runner.addCommand(TR());

    /// * Assets
    /// * generate assets
    runner.addCommand(AssetsMakeCommand());

    await runner.run(args);
  } on TrException catch (e) {
    print('LH :: Can\'t Generate TR File !');
    print('LH ::' + e.toString());
  } catch (e) {
    print(e.toString());
  }
}
