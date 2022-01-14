import 'package:path/path.dart';
import 'package:recase/recase.dart';

class RecaseManager {
  String findNameWithoutFormat(String path) {
    late final parts = <String>[];
    if (path.contains(separator)) {
      parts.addAll(path.split(separator));
    } else {
      parts.add(path);
    }
    final lastPart = parts.last.split('.');
    return lastPart.first;
  }

  /// generate the interface name
  String buildInterfaceName(
    String key, {
    bool private = true,
  }) =>
      '${private ? '_' : ''}${key.pascalCase}Interface';
}
