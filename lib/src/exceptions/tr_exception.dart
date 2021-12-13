class TrException implements Exception {}

class TrExceptionsList implements TrException {
  final List<TrException> exceptions;

  TrExceptionsList(this.exceptions);
  @override
  String toString() {
    exceptions.sort(
      (a, b) => a.runtimeType.toString().compareTo(b.runtimeType.toString()),
    );
    return exceptions.join('\n');
  }
}

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
    return 'key "$key" not found in language "$language" .';
  }
}

/// thrown when generation a Tr file and found a empty key
class EmptyKey implements TrException {
  final String key;
  final String language;

  const EmptyKey({required this.key, required this.language});

  @override
  String toString() {
    return '$key in language $language is empty .';
  }
}

class BadKeyType implements TrException {
  final String key;
  final String language;
  final Type type;

  const BadKeyType({
    required this.key,
    required this.language,
    required this.type,
  });

  @override
  String toString() {
    return 'key $key in $language is $type which is not supported only add String and Map only !  .';
  }
}
