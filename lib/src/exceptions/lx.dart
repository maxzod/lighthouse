abstract class LX implements Exception {
  final String message;
  final int code;
  LX(this.message, this.code);
  @override
  String toString() => message;
}

class NoAssetsException extends LX {
  NoAssetsException() : super("assets directory is empty", 0);
}
