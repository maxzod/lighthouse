class FileDoesNotExist implements Exception {
  final String path;

  FileDoesNotExist(this.path);

  @override
  String toString() {
    return 'Directory $path does not exists';
  }
}
