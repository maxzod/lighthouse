import 'package:nations_assets/nations_assets.dart';

/// return the locale assets from `nations_assets` package
/// ! if the locale is not supported , will return empty map
Map<String, Object> findAssetsFromNations(String locale) {
  // TOOD :: use the method from the package
  switch (locale) {
    case 'ar':
      return arAssets;
    case 'en':
      return enAssets;
    case 'es':
      return esAssets;
    default:
      return const {};
  }
}
