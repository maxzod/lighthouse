import 'package:ansicolor/ansicolor.dart';

final _red = AnsiPen()..red(bold: true);
final _white = AnsiPen()..white(bold: true);
final _yellow = AnsiPen()..yellow(bold: true);

void red(String msg) => print(_red(msg));

void white(String msg) => print(_white(msg));

void yellow(String msg) => print(_yellow(msg));
