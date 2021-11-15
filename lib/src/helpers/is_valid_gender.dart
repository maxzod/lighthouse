// return true if is valid gender map
bool isValidGenderMap(Map<String, dynamic> map) {
  return map.containsKey('male') && map.containsKey('female');
}
