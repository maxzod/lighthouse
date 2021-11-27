import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/helpers/yaml.dart';

void main() {
  group('getYamlAssets function', () {
    test('it should return flutter.assets content from pubspec.yaml', () {
      final assets = getYamlAssets();
      expect(assets.isNotEmpty, isTrue);
      expect(
          assets,
          equals([
            'assets/',
          ]));
    });
  });
}
