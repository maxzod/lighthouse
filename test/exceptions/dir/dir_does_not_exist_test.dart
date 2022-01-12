import 'package:lighthouse/src/exceptions/file.dart';
import 'package:test/test.dart';

void main() {
  test('it return the path in the message', () {
    final exception = DirDoesNotExist('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
  });
  test('it return the path in the message', () {
    final exception = DirDoesNotContainJsonFiles('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
    expect(exception.toString(), contains('json'));
  });
}
