import 'package:lighthouse/src/managers/recase.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  final manger = RecaseManager();
  group('findNameWithoutFormat', () {
    test('if file path contains parents remove them', () {
      final name =
          manger.findNameWithoutFormat('foo${separator}bar${separator}zee');
      expect(name, 'zee');
    });

    test('if removes the file extension if exist', () {
      final name = manger.findNameWithoutFormat('foo_bar_zee.png');
      expect(name, 'foo_bar_zee');
    });
  });
  group('buildInterfaceName', () {
    test('if covert the name to pascal', () {
      final name = manger.buildInterfaceName('foo');
      expect(name.contains('Foo'), isTrue);
    });
    test('if private add _', () {
      final name = manger.buildInterfaceName('foo', private: false);
      final name2 = manger.buildInterfaceName('foo', private: true);
      expect(name, 'FooInterface');
      expect(name2, '_FooInterface');
    });

    test('if removes the file extension if exist', () {
      final name = manger.findNameWithoutFormat('foo_bar_zee.png');
      expect(name, 'foo_bar_zee');
    });
  });

  // test('if convert the name to camel case', () {
  //   final name = manger.findNameWithoutFormat('foo_bar_zee.png');
  //   expect(name, 'foo_bar_zee');
  // });
  // test('', (){});
  // test('', (){});
  // test('', (){});
  // test('', (){});
}
