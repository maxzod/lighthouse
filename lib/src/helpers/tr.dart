import 'package:lighthouse/queen_map/queen_map.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';
import 'package:lighthouse/src/type_defs.dart';

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
