import 'package:lighthouse/queen_map/queen_map.dart';
import 'package:lighthouse/src/commands/tr/make.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';

/// * return which key is missing from which locale
List<TrException> findKeyProblem({
  required String key,
  required FullAssets fullAssets,
}) {
  final result = <TrException>[];
  for (final lang in fullAssets.supportedLocales) {
    final keyValue = findInMap(key, fullAssets.assets[lang]!);

    if (keyValue == null) {
      result.add(MissingKey(key: key, language: lang));
    } else {
      final value = fullAssets.assets[lang]![key];
      if (value is String) {
        if (value.isEmpty) {
          result.add(EmptyKey(key: key, language: lang));
        }
      } else if (value is Map<String, dynamic>) {
        if (value.isEmpty) {
          result.add(EmptyKey(key: key, language: lang));
        }
      } else {
        result.add(BadKeyType(
          key: key,
          language: lang,
          type: value.runtimeType,
        ));
      }
    }
  }
  return result;
}
