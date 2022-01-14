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

class IsNotDirPath extends LX {
  IsNotDirPath(String path) : super(path, 1);
  @override
  String toString() => '$message must be a directory path';
}
