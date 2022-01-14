import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:lighthouse/src/managers/file_manager.dart';
import 'package:lighthouse/src/mixins.dart';
import 'package:lighthouse/src/managers/pubspec_manager.dart';
import 'package:yaml_edit/yaml_edit.dart';

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
  Future<void> run() async {
    final usedPackagesList =
        pubSpecManager.getPubspecDependencies(File('pubspec.yaml')).toList();

    final projectFiles =
        await filesManager.girDirectoryChildrenFlat(Directory('lib'));

    for (final projectFile in projectFiles) {
      if (usedPackagesList.isEmpty) break;
      final fileContent = await projectFile.readAsString();
      final toRemove = <String>[];
      for (final package in usedPackagesList) {
        if (fileContent.contains('package:${package.key}/')) {
          toRemove.add(package.key);
        }
      }
      usedPackagesList.removeWhere((element) => toRemove.contains(element.key));
    }
    final unusedPackages =
        usedPackagesList.map((element) => element.key).toList();
    String msg = '';
    for (final package in unusedPackages) {
      msg = msg + '- $package\n';
    }
    print('''
    these packages are not used
    $msg
    ''');
    final dialog = CLI_Dialog(booleanQuestions: [
      ['are you sure you want to remove them from pubspec.yaml ?', 'isHappy']
    ]);
    final answer = dialog.ask()['isHappy'];
    if (answer) {
      // update pubspec.yaml
      /// read the content of `pubspec.yaml` file
      final pubspecContent = await File('pubspec.yaml').readAsString();

      /// create editor to edit the `[flutter][assets]` tag
      final doc = YamlEditor(pubspecContent);
      for (final package in unusedPackages) {
        doc.remove(['dependencies', package]);
      }

      /// this line will delete the old content

      /// save the pubspec.yaml file
      File('pubspec.yaml').writeAsString(doc.toString());
    }
  }

  @override
  String get successMessage => "unused packages removed";
}
