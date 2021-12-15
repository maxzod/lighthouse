import 'package:flutter_test/flutter_test.dart';
import 'package:lighthouse/queen_map/queen_map.dart';

void main() {
  group(
    'findInMap',
    () {
      test(
        'if the path is not nested will return the value directly',
        () {
          final path = 'foo';
          final map = {'foo': 'bar'};
          final result = findInMap(path, map);
          expect(result, 'bar');
        },
      );
      test(
        'if the path is does not exist it will return null',
        () {
          final path = 'foo.zee';
          final map = {'foo': 'bar'};
          final result = findInMap(path, map);
          expect(result, null);
        },
      );
      test(
        'if the contains . and mot nested it will return the value directly',
        () {
          final path = 'foo.';
          final map = {'foo': 'bar'};
          final result = findInMap(path, map);
          expect(result, 'bar');
        },
      );
      test(
        'if the nested it will return the nested value',
        () {
          final path = 'foo.bar.zee';
          final map = {
            'foo': {
              'bar': {
                'zee': 'xyz',
              },
            },
          };
          final result = findInMap(path, map);
          expect(result, 'xyz');
        },
      );
    },
  );

  group('flatMapKeys', () {
    test('it return empty list if the map is empty', () {
      final result = flatMapKeys({});
      expect(result, []);
    });
    test('it can flat simple map', () {
      final result = flatMapKeys({'foo': 'bar'});
      expect(result, ['foo']);
    });
    test('it the  flat simple map', () {
      final result = flatMapKeys({'foo': 'bar'});
      expect(result, ['foo']);
    });
    test('it the  flat nested map', () {
      final result = flatMapKeys({
        'foo': 'bar',
        'zee': {
          'xyz': 'abc',
          'baz': '123',
          "lvl3": {
            "lvl4": {
              "lvl5": "end",
            },
          },
        }
      });
      expect(result, [
        'foo',
        'zee',
        'zee.xyz',
        'zee.baz',
        'zee.lvl3',
        'zee.lvl3.lvl4',
        'zee.lvl3.lvl4.lvl5',
      ]);
    });
  });
}
