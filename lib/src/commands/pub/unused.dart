import 'dart:io';

import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/mixins.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';

class RemoveUnUsedPackagesCommand extends LightHouseCommand {
  final FilesManager filesManager;
  final PubSpecManager pubSpecManager;

  RemoveUnUsedPackagesCommand({
    required this.filesManager,
    required this.pubSpecManager,
  });
  @override
  String get description => 'remove unused packages from pubspec.yaml';

  @override
  String get name => 'pub:unused';

  @override
  String get successMessage => "unused packages removed";

  String get pubspecPath => 'pubspec.yaml';

  String get filesDir => 'lib';

  @override
  Future<void> run() async {
    final unused = await pubSpecManager.findUnUsedPackages(
      File(pubspecPath),
      Directory(filesDir),
    );

    await pubSpecManager.removeDependencies(File(pubspecPath), unused);

    print('💡 done');
    print('removed\n${unused.join('\n')}');
  }
}
