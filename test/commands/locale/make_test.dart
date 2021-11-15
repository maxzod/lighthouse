import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/helpers/is_valid_gender.dart';

void main() {
  group(':make', () {
    test('it make valid gender object', () {
      expect(
        isValidGenderMap({'male': 'foo'}),
        isFalse,
        reason: 'does not contain a female key',
      );
      expect(
        isValidGenderMap({'female': 'foo'}),
        isFalse,
        reason: 'does not contain a male key',
      );
      expect(
        isValidGenderMap({'male': 'foo', 'female': 'foo'}),
        isTrue,
        reason: 'contains both female and male',
      );
    });
  });
}
