import 'dart:convert';
import 'dart:io';

import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;
import 'logger.dart' as logger;

DateTime get _nowTime => DateTime.now();
String get now =>
    '${_nowTime.year}-${_nowTime.month}-${_nowTime.day} ${_nowTime.hour}:${_nowTime.minute}';
// app process
Process? process;

Future<void> boot(String fileName) async {
  if (!File(fileName).existsSync()) {
    /// print error msg
    logger.red('[🔥] ❌ cant run the app');
    logger.red('[🔥] ❌ File $fileName not found.');

    /// go back
    return;
  }

  ///  kill the old process
  process?.kill(ProcessSignal.sigkill);

  /// fire up new `Process`
  process = await Process.start('dart', [fileName]);
  // print The standard output stream of the process
  process!.stdout.transform(utf8.decoder).listen(print);

  /// print The standard error stream of the process
  process!.stderr.transform(utf8.decoder).listen(print);
}

Future<void> fire({String filename = './bin/main.dart'}) async {
  /// current project path
  final _watcher = DirectoryWatcher(p.absolute(Directory.current.path));

  /// print msg
  logger.yellow('[🔥] lighthouse is ON ');

  /// start the app for the first time
  await boot(filename);

  /// listen for file system changes
  _watcher.events.listen((WatchEvent e) async {
    /// changed file shorten name
    final changedFile = e.path.replaceAll(Directory.current.path, '');

    /// print msg
    logger.red('[🔥] 🕛 changes occurred in $changedFile at [$now]');

    /// restart the app
    try {
      /// print msg
      logger.white('[🔥] 🔋 restarting the app');

      /// boot the app
      await boot(filename);

      /// print success message
      logger.yellow('[🔥] ✔️  app is running');
    } catch (e) {
      /// print error msg
      logger.red("[🔥] ❌ can't run the app");

      /// print the captured exception
      logger.yellow(e.toString());
    }
  });
}

void main(List<String> arguments) {
  // turn the lighthouse on 🔥

  if (arguments.isEmpty) {
    fire();
  } else if (arguments.length == 1) {
    if (arguments.first == 'help') {
      logger.white('''
    [🔥] 🧾
    lighthouse available commands :
    lighthouse => to run bin/main.dart and watch for changes an the entire project 
    lighthouse <file-name> => to run <file-name> and watch for changes an the entire project 
    
    for easy of use you can use replace lighthouse with `lh` and it will work the same 
    lh => to run bin/main.dart and watch for changes an the entire project 
    lh <file-name> => to run <file-name> and watch for changes an the entire project
     
    ''');
    } else {
      fire(filename: arguments.first);
    }
  } else {
    logger.red(
        'only pass one argument either help or the entry point to your project');
  }
}
