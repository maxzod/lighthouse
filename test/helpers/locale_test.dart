import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/helpers/file.dart';

void main() {
  group('supportedLocales function', () {
    test('should return supported locales', () {
      final sLocales =
          findSupportedLocales([File('ar.json'), File('foo/en.json')]);
      expect(sLocales, ['ar', 'en']);
    });
  });

  group('keyMissingLangs function', () {
    test('should throw missing keys ', () {
      // expect(
      //     () => findKeyProblem(
      //           key: 'foo',
      //           fullAssets: {
      //             'ar': {},
      //             'en': {'foo': 'bar'}
      //           },
      //         ),
      //     throwsA(isA<MissingKey>()));
    });
  });
}
