class FileException implements Exception {
  final String path;
  FileException(this.path);
}

class DirDoesNotContainJsonFiles extends FileException {
  DirDoesNotContainJsonFiles(String path) : super(path);

  @override
  String toString() => 'Directory $path does not contains any json files !';
}

class FileDoesNotExist extends FileException {
  FileDoesNotExist(String path) : super(path);

  @override
  String toString() => 'Directory $path does not exists';
}

class DirDoesNotExist extends FileDoesNotExist {
  DirDoesNotExist(String path) : super(path);
}
