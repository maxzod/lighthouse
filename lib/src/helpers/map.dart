/// return the key with parents as string separated by `.`
/// example :
///  ```json
///         "key1": {
///            "key2": {
///               "key3": "some value"
///           }
///      }
/// ```
///  will be => `[key1,key2,key3]`  will be `key1.key2.key3`
String buildFlatKey(String key, List<String> parents) {
  if (parents.isEmpty || parents.length < 2) {
    /// is not nested
    return key;
  } else {
    return parents.join('.');
  }
}
