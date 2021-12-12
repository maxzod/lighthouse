import 'package:collection/collection.dart';

/// * merges to maps into single one
/// * if the key found in both maps it will use the one from the second map
dynamic mergeTwoMaps(dynamic a, dynamic b) {
  if (a is Map<String, Object?> && b is Map<String, Object?>) {
    return mergeMaps<String, dynamic>(a, b, value: mergeTwoMaps);
  }
  return b;
}
