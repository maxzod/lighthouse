import 'package:lighthouse/src/commands/locale/make.dart';

void main(List<String> args) async {
  if (args.isEmpty) return;
  if (args.first == 'tr:make') {
    await LocaleMakeCommand().handle(args);
    // TODO :: format after makeing
    print('done 👑');
  } else {
    print(args.join());
  }
}
