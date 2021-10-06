class DirDoesNotExist implements Exception {
  final String path;

  const DirDoesNotExist(this.path);
  @override
  String toString() {
    return 'dir : "$path" does not exist !';
  }
}
