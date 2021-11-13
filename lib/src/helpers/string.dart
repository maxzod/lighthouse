import 'package:lighthouse/src/helpers/is_valid_gender.dart';

import '../enums.dart';

ValueType feildType(dynamic value) {
  if (value is String) {
    return ValueType.string;
  } else if (value is Map<String, dynamic>) {
    if (isValidGenderMap(value)) {
      return ValueType.gender;
    } else {
      return ValueType.nested;
    }
  }
  throw UnsupportedError('type $value is not supported');
}
