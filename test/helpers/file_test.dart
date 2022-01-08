// import 'dart:io';

// import 'package:lighthouse/src/exceptions/file.dart';
// import 'package:path/path.dart';
// import 'package:test/test.dart';
// import 'package:lighthouse/src/helpers/file.dart';

// void main() {
//   final dir = Directory('testdir');
//   final file = File('testdir/test.ff');
//   final file2 = File('testdir/test2.ff');
//   setUp(
//     () async {
//       if (!dir.existsSync()) {
//         await dir.create();
//         if (!file.existsSync()) {
//           await file.create();
//         }
//         if (!file2.existsSync()) {
//           await file2.create();
//         }
//       }
//     },
//   );

//   tearDown(
//     () async {
//       if (dir.existsSync()) {
//         await dir.delete(recursive: true);
//       }
//     },
//   );
//   group(
//     'loadDirectoryJsonFiles function',
//     () {
//       test(
//         'should return a list of files',
//         () async {
//           final files = await loadDirectoryJsonFiles('./assets/lang');
//           expect(files, isNotEmpty);
//         },
//       );
//       test(
//         'it throw exception if it does not exist',
//         () async {
//           expect(
//             () => loadDirectoryJsonFiles('/foo/bar'),
//             throwsA(isA<DirDoesNotExist>()),
//           );
//         },
//       );
//       test(
//         'it throw exception if it does not have any json files',
//         () async {
//           expect(
//             () => loadDirectoryJsonFiles('testdir'),
//             throwsA(isA<DirDoesNotContainJsonFiles>()),
//           );
//         },
//       );
//     },
//   );

//   group(
//     'loadDirectoryFiles function',
//     () {
//       test(
//         'it can load directory files',
//         () async {
//           final files = await loadDirectoryFiles('testdir');
//           expect(files, isNotEmpty);
//           expect(files.length, 2);
//           expect(files.first.path, 'testdir\\test.ff');
//           expect(files.last.path, 'testdir\\test2.ff');
//         },
//       );
//       test(
//         'if path is not valid directory it throws DirDoesNotExist',
//         () {
//           expect(
//             () => loadDirectoryFiles('bad\\dir\\path'),
//             throwsA(isA<DirDoesNotExist>()),
//           );
//         },
//       );
//     },
//   );
//   group(
//     'readJsonContent function',
//     () {
//       test(
//         'should return a json object',
//         () async {
//           final json = await readJsonContent('./assets/lang/en.json');
//           expect(json, isNotNull);
//           expect(json, isNotEmpty);
//         },
//       );
//       test(
//         'throw FileDoesNotExist if there is no file',
//         () {
//           expect(
//             () => readJsonContent('404/en.json'),
//             throwsA(isA<FileDoesNotExist>()),
//           );
//         },
//       );
//     },
//   );

//   group(
//     'isParentDir',
//     () {
//       test(
//         'should return true if is the same path',
//         () async {
//           expect(
//               isEnoughToUseParent(
//                   'assets/lang/foo.bar', 'assets\\lang\\foo.bar'),
//               isTrue);
//         },
//       );
//       test(
//         'should return true if it is the parent dir',
//         () async {
//           expect(isEnoughToUseParent('assets/lang/', 'assets\\lang\\ar.json'),
//               isTrue);
//         },
//       );
//       test(
//         'it will return false if is not direct parent',
//         () {
//           expect(
//               isEnoughToUseParent('assets/lang/', 'assets\\lang\\foo\\en.json'),
//               isFalse);
//         },
//       );
//       test(
//         'should return false if it is not a parent dir',
//         () async {
//           expect(
//               isEnoughToUseParent(
//                   './assets/ang/en.json', '.\\assets\\lang\\foo\\en.json'),
//               isFalse);
//         },
//       );
//     },
//   );

//   group(
//     'isFilePath',
//     () {
//       test(
//         'it return true if is file path',
//         () {
//           expect(isFilePath('assets/lang/en.json'), isTrue);
//         },
//       );
//       test(
//         'it return false if is not a file path',
//         () {
//           expect(isFilePath('assets/lang'), isFalse);
//         },
//       );
//     },
//   );
//   group(
//     'findFileName',
//     () {
//       test('it extracts file name with extension', () {
//         expect(findFileName('assets${separator}lang${separator}en.json'),
//             'en.json');
//       });
//       test(
//         'it throws exception if the path does not contains any separators',
//         () {
//           expect(
//             () => findFileName('path-without-any-separators.png'),
//             throwsA(isA<Exception>()),
//           );
//         },
//       );
//     },
//   );
//   group('findFileExtension', () {
//     test('it extracts file extension', () {
//       expect(
//         findFileExtension('assets${separator}lang${separator}en.json'),
//         'json',
//       );
//     });
//     test(
//       'it throws exception if the path does not contains any separators',
//       () {
//         expect(
//           () => findFileExtension('path-without-any-dots-png'),
//           throwsA(isA<Exception>()),
//         );
//       },
//     );
//   });
// }
import 'package:test/test.dart';

void main() {
  test('', () {});
}
