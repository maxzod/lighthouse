import 'package:test/test.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';

void main() {
  test('it return the key and the language in the message', () {
    final exception = MissingKey(key: 'foo', language: 'ar');
    expect(exception.toString(), contains('foo'));
    expect(exception.toString(), contains('ar'));
  });
}
