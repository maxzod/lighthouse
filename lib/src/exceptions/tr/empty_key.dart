import 'package:lighthouse/src/exceptions/tr/tr_exception.dart';

/// thrown when generation a Tr file and found a empty key
class EmptyKey implements TrException {
  final String key;
  final String language;

  const EmptyKey({required this.key, required this.language});

  @override
  String toString() {
    return ' ⚡ ❌  EmptyKey  ::  $key in language $language is empty .';
  }
}
