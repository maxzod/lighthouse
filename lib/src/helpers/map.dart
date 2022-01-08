// // TODO :: move to readable
// /// return the key with parents as string separated by `.`
// /// example :
// ///  ```json
// ///         "key1": {
// ///            "key2": {
// ///               "key3": "some value"
// ///           }
// ///      }
// /// ```
// ///  will be => `[key1,key2,key3]`  will be `key1.key2.key3`
// String buildFlatKey(String root, List<String> parents) {
//   // TODO :: why less than 2 isEmpty alone should be enough !
//   if (parents.isEmpty || parents.length < 2) {
//     /// is not nested
//     return root;
//   } else {
//     return parents.join(
//         // TODO :: feat :: seprator
//         '.');
//   }
// }
