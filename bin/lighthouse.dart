import 'package:args/command_runner.dart';
import 'package:lighthouse/src/commands/init.dart';
import 'package:lighthouse/src/commands/tr.dart';

void main(List<String> args) async {
  try{
  final runner = CommandRunner('lh, lighthouse', 'manages our Queen framework');
  runner.addCommand(Init());
  runner.addCommand(TR());
  await runner.run(args);
  }catch(e){
    print(e);
  }
}

