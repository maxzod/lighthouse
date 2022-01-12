import 'dart:io';

import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:lighthouse/src/managers.dart';

import '../../mixins.dart';

class AssetsAddCommand extends LightHouseCommand {
  final PubSpecManager yamlManager;
  final FilesManager filesManager;

  AssetsAddCommand({
    required this.yamlManager,
    required this.filesManager,
  });

  /// command description
  @override
  String get description => 'add assets folder content to pubspec.yaml';

  /// command name
  @override
  String get name => 'assets:add';

  @override
  Future<void> run() async {
    /// find children from '/assets` directory
    final assetsDirChildren = filesManager.dirChildren(Directory('assets'));

    if (assetsDirChildren.isEmpty) throw NoAssetsException();

    /// remove unnecessary paths
    final result = filesManager.removeUnNecessaryChildren(assetsDirChildren);

    ///  write them to the `pubspec.yaml` `[flutter][assets]`
    await yamlManager.setAssets(result);
  }

  @override
  String get successMessage => 'assets added';
}
