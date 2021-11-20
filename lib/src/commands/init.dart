import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:args/command_runner.dart';

class Init extends Command {
  @override
  final name = 'init';

  @override
  final description = 'init the project with your folders';

  @override
  void run() async {
    final bytes = File('./lib.zip').readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    extractArchiveToDisk(archive, './archotest');
  }
}
