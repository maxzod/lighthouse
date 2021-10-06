import '../enums.dart';

ValueType feildType(dynamic value) {
  if (value is String) {
    return ValueType.string;
  } else if (value is Map) {
    if (value.containsKey('male') && value.containsKey('female')) {
      return ValueType.gender;
    } else {
      return ValueType.nested;
    }
  }
  throw UnsupportedError('type $value is not supported');
}
