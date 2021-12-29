import 'package:lighthouse/src/helpers/map.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('buildFlatKey', () {
    expect(
      buildFlatKey('', ['1', '2', '3']),
      '1.2.3',
    );
  });
}
