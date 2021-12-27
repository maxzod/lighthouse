import 'package:flutter_readable/flutter_readable.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';
import 'package:lighthouse/src/types.dart';

import 'locale.dart';

void validateLocalizationAssets(
  List<String> fullKeys,
  FullAssets fullAssets,
) {
  final buggedKeys = <TrException>[];
  //throw fullAssets['ar']!['paste']!;
  for (final lang in fullAssets.keys) {
    for (final key in fullKeys) {
      final value = findInMap(key, fullAssets[lang]!);
      buggedKeys.addAll(
        validateTranslationKey(
          key: key,
          value: value,
          lang: lang,
        ),
      );
    }
  }

  if (buggedKeys.isNotEmpty) throw TrExceptionsList(buggedKeys);
}
