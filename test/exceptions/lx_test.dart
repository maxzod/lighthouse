import 'package:lighthouse/src/exceptions/lx.dart';
import 'package:test/test.dart';

class _TestLX extends LX {
  _TestLX(String message, int code) : super(message, code);
}

void main() {
  test(
    'LX toString() contains the message',
    () => expect(_TestLX('foo', 1).toString(), contains('foo')),
  );
}
