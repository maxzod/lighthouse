import 'package:lighthouse/src/exceptions/tr_exception.dart';

/// * return which key is missing from which locale
List<TrException> validateTranslationKey({
  required String key,
  required Object? value,
  required String lang,
}) {
  final result = <TrException>[];

  if (value == null) {
    result.add(MissingKey(key: key, language: lang));
  } else if (value is String) {
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
  return result;
}
