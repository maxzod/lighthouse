import 'package:test/test.dart';
import 'package:lighthouse/src/exceptions/tr_exception.dart';

void main() {
  test('it return the key and the language in the message', () {
    final exception = TrExceptionsList([
      EmptyKey('key2', 'lang'),
      EmptyKey('key1', 'lang'),
      EmptyKey('key3', 'lang'),
    ]);
    final msg = exception.toString();

    /// contains all keys;
    expect(msg, contains('key1'));
    expect(msg, contains('key2'));
    expect(msg, contains('key3'));

    /// sort the errors
    expect(
        msg,
        TrExceptionsList([
          EmptyKey('key1', 'lang'),
          EmptyKey('key2', 'lang'),
          EmptyKey('key3', 'lang'),
        ]).toString());
  });

  test(
    'MissingKey toString() contains the key',
    () => expect(MissingKey('foo', 'ar').toString(), contains('foo')),
  );
  test(
    'MissingKey toString() contains the lang',
    () => expect(MissingKey('foo', 'ar').toString(), contains('foo')),
  );
  test(
    'BadKeyType toString() contains the key',
    () => expect(
        BadKeyType(key: 'foo', language: 'ar', type: String).toString(),
        contains('foo')),
  );
  test(
    'BadKeyType toString() contains the lang',
    () => expect(
        BadKeyType(key: 'foo', language: 'ar', type: String).toString(),
        contains('foo')),
  );
}
