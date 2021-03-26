import 'dart:convert';
import 'dart:io';

import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import 'logger.dart';

// app process
Process? process;

Future<void> boot() async {
  const mainFile = './lib/main.dart';
  if (!File(mainFile).existsSync()) {
    /// print error msg
    Logger.red('❌ cant run the app');
    Logger.red('❌ File $mainFile not found.');

    /// go back
    return;
  }

  ///  kill the old process
  process?.kill(ProcessSignal.sigkill);

  /// fire up new `Process`
  process = await Process.start('dart', [mainFile]);
  // print The standard output stream of the process
  process!.stdout.transform(utf8.decoder).listen(print);

  /// print The standard error stream of the process
  process!.stderr.transform(utf8.decoder).listen(print);
}

Future<void> fire() async {
  /// current project path
  final _watcher = DirectoryWatcher(p.absolute(Directory.current.path));

  /// print msg
  Logger.yellow('lighthouse is ON 🔥');

  /// start the app for the first time
  await boot();

  /// listen for file system changes
  _watcher.events.listen((WatchEvent e) async {
    /// changed file shorten name
    final changedFile = e.path.replaceAll(Directory.current.path, '');

    /// print msg
    Logger.red('🕛 ${DateTime.now().toIso8601String()} changes occurred on $changedFile');

    /// restart the app
    try {
      /// print msg
      Logger.white('🔋 restarting the app');

      /// boot the app
      await boot();

      /// print success message
      Logger.yellow('✔️ app is running');
    } catch (e) {
      /// print error msg
      Logger.red('❌ cant run the app');

      /// print the captured exception
      Logger.yellow(e.toString());
    }
  });
}

void main(List<String> arguments) {
  // turn the lighthouse on 🔥
  fire();
}
