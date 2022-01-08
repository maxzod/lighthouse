// import 'dart:io';

// import 'package:lighthouse/src/exceptions/tr_exception.dart';
// import 'package:lighthouse/src/helpers/locale.dart';
// import 'package:lighthouse/src/helpers/nations_assets.dart';
// import 'package:test/test.dart';
// import 'package:lighthouse/src/helpers/file.dart';

// void main() {
//   group('supportedLocales function', () {
//     test('should return supported locales', () {
//       final sLocales =
//           findSupportedLocales([File('ar.json'), File('foo/en.json')]);
//       expect(sLocales, ['ar', 'en']);
//     });
//   });
//   group('nations_assets loader', () {
//     test('should support ar ,eb es, locales', () {
//       for (var locale in ['ar', 'en', 'es']) {
//         expect(findAssetsFromNations(locale), isNotEmpty);
//       }
//     });
//   });

//   group('validateTranslationKey function', () {
//     test('can detect if string is empty ', () {
//       final bugs = validateTranslationKey(key: 'foo', lang: 'ar', value: '');
//       expect(bugs, contains(isA<EmptyKey>()));
//     });
//     test('can detect if map is empty ', () {
//       final bugs = validateTranslationKey(key: 'foo', lang: 'ar', value: {});
//       expect(bugs, contains(isA<EmptyKey>()));
//     });
//     test('can detect if value is null ', () {
//       final bugs = validateTranslationKey(key: 'foo', lang: 'ar', value: null);
//       expect(bugs, contains(isA<MissingKey>()));
//     });
//     test('can detect if value is a bad type ', () {
//       final bugs = validateTranslationKey(key: 'foo', lang: 'ar', value: 1);
//       expect(
//         bugs,
//         contains(isA<BadKeyType>()),
//         reason:
//             'integers is not a string or map to hold another key so it is a bad type',
//       );
//     });
//   });

//   group('validateLocalizationAssets', () {
//     // test('it validates all languages', () {});
//     test('it validates all languages', () {
//       try {
//         validateLocalizationAssets([
//           'foo',
//         ], {
//           'ar': {
//             'foo': '',
//           },
//           'en': {
//             'foo': '',
//           },
//           'es': {
//             'foo': '',
//           }
//         });
//       } on TrExceptionsList catch (e) {
//         final bugs = e.exceptions;
//         expect(bugs, isNotEmpty);
//         expect(bugs.length, 3);
//       }
//     });
//   });
// }
import 'package:test/test.dart';

void main() {
  test('', () {});
}
