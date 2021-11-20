import 'package:lighthouse/src/exceptions/tr/tr_exception.dart';

class BadKeyType implements TrException {
  final String key;
  final String language;
  final String type;

  const BadKeyType({
    required this.key,
    required this.language,
    required this.type,
  });

  @override
  String toString() {
    return 'BadKeyType: $key in $language is $type which is not supported only add String and Map only !';
  }
}
