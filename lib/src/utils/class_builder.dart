import 'package:recase/recase.dart';

class ClassGetter {
  final String returnType;
  final String name;
  final String whatToReturn;
  final bool isStatic;
  final bool isPrivate;

  ClassGetter({
    required this.returnType,
    required this.name,
    required this.whatToReturn,
    this.isStatic = true,
    this.isPrivate = false,
  });

  @override
  String toString() {
    return "${isStatic ? 'static' : ''} $returnType get ${isPrivate ? '_' : ''} ${name.camelCase} => $whatToReturn;";
  }
}

class ClassBuilder {
  final String name;
  final List<String> imports;
  final List<String> topComments;
  final bool havePrivateConstractor;
  final _getters = <ClassGetter>[];

  ClassBuilder({
    required this.name,
    this.imports = const [],
    this.topComments = const [],
    this.havePrivateConstractor = true,
  });

  void addGetter(ClassGetter getter) {
    _getters.add(getter);
  }

  void addGettersList(List<ClassGetter> getters) {
    _getters.addAll(getters);
  }

  @override
  String toString() {
    final _strClass = '''
    $_topComments
    $_imports
    class $_className {
      
      $_className${havePrivateConstractor ? '._' : ''} ();

      $_classGetters

    }
     
    ''';
    return _strClass;
  }

  String get _className => name.pascalCase;

  String get _classGetters {
    final _buffer = StringBuffer();
    _getters.forEach(_buffer.writeln);
    return _buffer.toString();
  }

  String get _imports {
    final _buffer = StringBuffer();
    imports.forEach(_buffer.writeln);
    return _buffer.toString();
  }

  String get _topComments {
    final _buffer = StringBuffer();
    topComments.forEach(_buffer.writeln);
    return _buffer.toString();
  }
}
