import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:test/test.dart';
import 'package:lighthouse/src/exceptions/file.dart';

import 'package:lighthouse/src/exceptions/tr_exception.dart';

class _TestLX extends LX {
  _TestLX(String message, int code) : super(message, code);
}

void main() {
  test(
    'LX toString() contains the message',
    () => expect(_TestLX('foo', 1).toString(), contains('foo')),
  );
  test('it return the path in the message', () {
    final exception = DirDoesNotContainJsonFiles('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
    expect(exception.toString(), contains('json'));
  });

  test('it return the path in the message', () {
    final exception = DirDoesNotExist('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
  });
  test('it return the path in the message', () {
    final exception = DirDoesNotContainJsonFiles('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
    expect(exception.toString(), contains('json'));
  });

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
