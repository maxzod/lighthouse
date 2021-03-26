import 'package:ansicolor/ansicolor.dart';

abstract class Logger {
  static final _red = AnsiPen()..red(bold: true);
  static final _white = AnsiPen()..white(bold: true);
  static final _yellow = AnsiPen()..yellow(bold: true);

  static void red(String msg) {
    print(Logger._red(msg));
  }

  static void white(String msg) {
    print(Logger._white(msg));
  }

  static void yellow(String msg) {
    print(Logger._yellow(msg));
  }
}
