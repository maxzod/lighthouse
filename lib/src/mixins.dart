import 'package:args/command_runner.dart';

abstract class LightHouseCommand extends Command {
  String get successMessage;
}
