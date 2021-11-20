import 'package:lighthouse/src/exceptions/tr/bad_key_type.dart';
import 'package:lighthouse/src/helpers/is_valid_gender.dart';

import '../enums.dart';

ValueType validateFelidType({
  required String key,
  required Object? value,
  String? language,
}) {
  if (value is String) {
    return ValueType.string;
  } else if (value is Map<String, dynamic>) {
    if (isValidGenderMap(value)) {
      return ValueType.gender;
    } else {
      return ValueType.nested;
    }
  }
  throw BadKeyType(
    key: key,
    language: language ?? 'null',
    type: value.runtimeType.toString(),
  );
}
