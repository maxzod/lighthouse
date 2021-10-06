class DirIsEmpty implements Exception {
  final String path;

  const DirIsEmpty(this.path);
  @override
  String toString() {
    return 'dir : "$path" is Empty !';
  }
}
