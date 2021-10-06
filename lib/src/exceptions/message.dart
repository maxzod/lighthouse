class MessageException implements Exception {
  final String msg;

  const MessageException(this.msg);
  @override
  String toString() => msg;
}
