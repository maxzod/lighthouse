import 'dart:io';

import 'package:lighthouse/lighthouse.dart';

void main(List<String> args) async {
  print('action');
  try {
    if (args.isEmpty) {
      print('[LH] args is Empty have to exit 🤷‍♀️');
      exit(0);
    } else if (args.first != 'make:locale') {
      print('[LH] command is not supported !');
      exit(0);
    } else {
      await MakeLocaleCommand().handle(args);
    }
  } catch (e, st) {
    print('[LH] EXCEPTION : $e');
    print(st);
  }
}
