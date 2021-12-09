import 'package:lighthouse/src/exceptions/tr/empty_key.dart';
import 'package:lighthouse/src/exceptions/tr/missing_key.dart';
import 'package:lighthouse/src/helpers/string.dart';

/// * return which key is missing from which locale
void findMissingKeys({
  required String key,
  required Map<String, Map<String, dynamic>> langsAssets,
  required List<String> supportedLangs,
}) {
  for (final lang in supportedLangs) {
    // TODO :: supporte nested
    final keyExist = langsAssets[lang]?.containsKey(key) ?? false;
    if (!keyExist) {
      throw MissingKey(key: key, language: lang);
    }
    final value = langsAssets[lang]![key];

    validateFelidType(key: key, value: value, language: lang);
    if (value.isEmpty) {
      throw EmptyKey(key: key, language: lang);
    }
  }
}
