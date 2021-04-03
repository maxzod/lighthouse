import 'dart:convert';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

abstract class Logger {
  static final _red = AnsiPen()..red(bold: true);
  static final _white = AnsiPen()..white(bold: true);
  static final _yellow = AnsiPen()..yellow(bold: true);

  static void red(String msg) {
    print(Logger._red(msg));
  }

  static void white(String msg) {
    print(Logger._white(msg));
  }

  static void yellow(String msg) {
    print(Logger._yellow(msg));
  }
}

// app process
Process? process;

Future<void> boot(String fileName) async {
  if (!File(fileName).existsSync()) {
    /// print error msg
    Logger.red('❌ cant run the app');
    Logger.red('❌ File $fileName not found.');

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
  Logger.yellow('lighthouse is ON 🔥');

  /// start the app for the first time
  await boot(filename);

  /// listen for file system changes
  _watcher.events.listen((WatchEvent e) async {
    /// changed file shorten name
    final changedFile = e.path.replaceAll(Directory.current.path, '');

    /// print msg
    Logger.red(
        '🕛 ${DateTime.now().toIso8601String()} changes occurred on $changedFile');

    /// restart the app
    try {
      /// print msg
      Logger.white('🔋 restarting the app');

      /// boot the app
      await boot(filename);

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

  if (arguments.isEmpty) {
    fire();
  } else if (arguments.length == 1) {
    if (arguments.first == 'help') {
      Logger._white('''
    lighthouse available commands :
    lighthouse => to run bin/main.dart and watch for changes an the entire project 
    lighthouse <file-name> => to run <file-name> and watch for changes an the entire project 

    for easy of use you can use replace lighthouse with lh and will work the same 
    lh => to run bin/main.dart and watch for changes an the entire project 
    lh <file-name> => to run <file-name> and watch for changes an the entire project 
    ''');
    } else {
      fire(filename: arguments.first);
    }
  } else {
    Logger.red('only pass one argument either help or the entry point path');
  }
}
