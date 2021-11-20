import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/exceptions/file/dir_is_empty.dart';

void main() {
  test('it return the path in the message', () {
    final exception = DirIsEmpty('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
  });
}
