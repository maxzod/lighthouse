import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/exceptions/tr/missing_key.dart';
import 'package:lighthouse/src/helpers/locale.dart';

void main() {
  group('supportedLocales function', () {
    test('should return supported locales', () {
      final sLocales = supportedLocales([File('ar.json'), File('foo/en.json')]);
      expect(sLocales, ['ar', 'en']);
    });
  });

  group('keyMissingLangs function', () {
    test('should throw missing keys ', () {
      expect(
          () => findMissingKeys(key: 'foo', supportedLangs: [
                'ar',
                'en'
              ], langsAssets: {
                'ar': {},
                'en': {'foo': 'bar'}
              }),
          throwsA(isA<MissingKey>()));
    });
  });
}
