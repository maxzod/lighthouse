// import 'package:lighthouse/src/exceptions/tr_exception.dart';

// import 'package:readable/readable.dart';
// import 'package:lighthouse/src/types.dart';

// /// * return which key is missing from which locale
// /// it only validates one key at a time
// List<TrException> validateTranslationKey({
//   required String key,
//   required Object? value,
//   required String lang,
// }) {
//   final result = <TrException>[];

//   if (value == null) {
//     result.add(MissingKey(key, lang));
//   } else if (value is String) {
//     if (value.isEmpty) {
//       result.add(EmptyKey(key, lang));
//     }
//   } else if (value is Map) {
//     if (value.isEmpty) {
//       result.add(EmptyKey(key, lang));
//     }
//   } else {
//     result.add(BadKeyType(
//       key: key,
//       language: lang,
//       type: value.runtimeType,
//     ));
//   }
//   return result;
// }

// /// validates the full assets
// void validateLocalizationAssets(
//   List<String> fullKeys,
//   FullAssets fullAssets,
// ) {
//   final buggedKeys = <TrException>[];
//   for (final lang in fullAssets.keys) {
//     for (final key in fullKeys) {
//       final value = findInMap(key, fullAssets[lang]!);
//       buggedKeys.addAll(
//         validateTranslationKey(
//           key: key,
//           value: value,
//           lang: lang,
//         ),
//       );
//     }
//   }

//   if (buggedKeys.isNotEmpty) throw TrExceptionsList(buggedKeys);
// }
