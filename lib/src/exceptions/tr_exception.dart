class TrException implements Exception {}

class TrExceptionsList implements TrException {
  final List<TrException> exceptions;

  TrExceptionsList(this.exceptions);
  @override
  String toString() {
    exceptions.sort(
      (a, b) => a.toString().compareTo(b.toString()),
    );
    return exceptions.join('\n');
  }
}

/// thrown when generation a Tr file and found a missing key
class MissingKey implements TrException {
  final String key;
  final String language;

  MissingKey(
    this.key,
    this.language,
  );

  @override
  String toString() => 'key "$key" not found in language "$language" .';
}

/// thrown when generation a Tr file and found a empty key
class EmptyKey implements TrException {
  final String key;
  final String language;

  EmptyKey(this.key, this.language);

  @override
  String toString() => '$key in language $language is empty .';
}

class BadKeyType implements TrException {
  final String key;
  final String language;
  final Type type;

  BadKeyType({
    required this.key,
    required this.language,
    required this.type,
  });

  @override
  String toString() =>
      'key $key in $language is $type which is not supported only add String and Map only !  .';
}
