import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/src/exceptions/file/dir_does_not_contain_json.dart';

void main() {
  test('it return the path in the message', () {
    final exception = DirDoesNotContainJsonFiles('foo/bar');
    expect(exception.toString(), contains('foo/bar'));
    expect(exception.toString(), contains('json'));
  });
}
