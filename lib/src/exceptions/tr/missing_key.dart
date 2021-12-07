import 'package:lighthouse/src/exceptions/tr/tr_exception.dart';

/// thrown when generation a Tr file and found a missing key
class MissingKey implements TrException {
  final String key;
  final String language;

  const MissingKey({
    required this.key,
    required this.language,
  });

  @override
  String toString() {
    return ' ⚡ ❌ MissingKey : key "$key" not found in language "$language" .';
  }
}
