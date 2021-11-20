class DirDoesNotContainJsonFiles implements Exception {
  final String path;

  DirDoesNotContainJsonFiles(this.path);

  @override
  String toString() {
    return 'Directory $path does not contains any json files !';
  }
}
