import 'package:test/test.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_exist.dart';

void main() {
  test('it return the path in the message', () {
    final exception = DirDoesNotExist('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
  });
}
