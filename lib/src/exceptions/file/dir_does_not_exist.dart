class DirDoesNotExist implements Exception {
  final String path;

  DirDoesNotExist(this.path);

  @override
  String toString() {
    return 'Directory $path does not exists';
  }
}
