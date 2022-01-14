import 'dart:io';

import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';

import '../../managers/file_manager.dart';
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
    final assetsDirChildren =
        await filesManager.findInnerContent(Directory('assets'));

    if (assetsDirChildren.isEmpty) throw NoAssetsException();

    /// remove unnecessary paths
    final result =
        await filesManager.removeUnNecessaryChildren(assetsDirChildren);

    ///  write them to the `pubspec.yaml` `[flutter][assets]`
    await yamlManager.setAssets(result, File('pubspec.yaml'));
  }

  @override
  String get successMessage => 'assets added';
}
