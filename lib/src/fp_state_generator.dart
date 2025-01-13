import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:fp_state_generator/fp_state_annotation.dart';
import 'package:fp_state_generator/src/generator_helper.dart';
import 'package:fp_state_generator/src/open_close_finder.dart';
import 'package:source_gen/source_gen.dart';
// ignore freezed

class FpStateGenerator extends GeneratorForAnnotation<FpState> {
  final Map<String, int> _freezedCache = {};
  final BigOpenCloseFinder _openCloseFinder = BigOpenCloseFinder();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final helper = await _initializeHelper(element, annotation, buildStep);
    if (helper == null) return '';

    final subClasses = await _getSubClasses(helper);
    if (subClasses == null) return '';

    final displayName =
        _buildDisplayName(element, helper.getGenericsType(helper.className));

    return '''
    extension FP$displayName on $displayName {
      ${_createMatch(helper.className, subClasses, helper)}

      ${_createMatchOrElse(helper.className, subClasses, helper)}
      
      ${_createMaybeMatch(helper.className, subClasses, helper)}

      ${_createSubClassMethods(helper.className, subClasses, helper)}
    }
    ''';
  }

  Future<GeneratorHelper?> _initializeHelper(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final helper = await GeneratorHelper(element, annotation, buildStep)
      ..getFileContent();
    await helper.fixPartImportContent();
    helper.isFreezed = _isClassFreezed(helper);
    return helper;
  }

  bool _isClassFreezed(GeneratorHelper helper) {
    final lines = helper.annotationSourceCode.split('\n');
    final className = helper.className;

    int idx = lines.indexWhere((l) => l.contains('class $className'));
    if (idx == -1) return false;

    while (idx > 0) {
      idx--;
      final line = lines[idx];
      if (line.contains("@Freezed") || line.contains('@freezed')) {
        _freezedCache[className] = idx;
        return true;
      }
      if (line.contains('}')) break;
    }
    return false;
  }

  Future<List<String>?> _getSubClasses(GeneratorHelper helper) async {
    if (helper.isFreezed) {
      return _getFreezedSubClasses(helper);
    }
    return _getNormalSubClasses(helper.annotationSourceCode, helper.className);
  }

  List<String>? _getFreezedSubClasses(GeneratorHelper helper) {
    final classLineStart = _freezedCache[helper.className];
    if (classLineStart == null) return null;

    final freezedClassLines =
        helper.annotationSourceCode.split('\n').sublist(classLineStart);

    return _parseFreezedSubClasses(freezedClassLines);
  }

  List<String> _parseFreezedSubClasses(List<String> lines) {
    final subClasses = <String>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('}')) break;

      if (line.contains('=')) {
        final subClass = line.endsWith('=')
            ? lines[i + 1].replaceAll(';', '').trim()
            : line.split('=').last.trim().replaceAll(';', '');
        subClasses.add(subClass);
      }
    }

    return subClasses;
  }

  List<String> _getNormalSubClasses(String sourceCode, String className) {
    final pattern =
        RegExp('class\\s+(\\w+)(?:<\\w*>)?\\s+extends\\s+$className');
    final matches =
        pattern.allMatches(sourceCode).map((e) => e.group(1)!).toList();
    return matches.isEmpty ? [className] : matches;
  }

  String _buildDisplayName(Element element, String genericsType) {
    final displayName = element.displayName;
    return genericsType.isEmpty ? displayName : '$displayName<$genericsType>';
  }

  String _createMatch(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final matchComponents =
        _createMatchComponents(className, subClasses, helper);

    return '''
    R match<R>({
      ${matchComponents.parameters},
    }) {
      final r = switch (this) {
        ${matchComponents.cases}
        $className() => throw Exception("\$runtimeType not match"),
      };
      return r;
    }
    ''';
  }

  String _createMatchOrElse(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final matchComponents =
        _createMatchOrElseComponents(className, subClasses, helper);

    return '''
    R matchOrElse<R>({
      ${matchComponents.parameters},
      required R Function($className data) orElse,
    }) {
      final r = switch (this) {
        ${matchComponents.cases}
        _ => orElse(this),
      };
      return r;
    }
    ''';
  }

  String _createMaybeMatch(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final matchComponents =
        _createMaybeMatchComponents(className, subClasses, helper);

    return '''
    R? maybeMatch<R>({
      ${matchComponents.parameters},
    }) {
      final r = switch (this) {
        ${matchComponents.cases}
        _ => throw Exception("\$runtimeType not match"),
      };
      return r;
    }
    ''';
  }

  String _createSubClassMethods(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    return subClasses.map((subClass) {
      final classInfo = _getClassInfo(subClass, className, helper);
      final methodName = '${subClass.toCamelCase()}OrNull';
      final returnType = classInfo.hasMember
          ? '$subClass${classInfo.genericsSuffix}?'
          : '$subClass?';

      return '''
      $returnType $methodName() {
        return switch (this) {
          $subClass${classInfo.genericsSuffix}() => this as $subClass${classInfo.genericsSuffix},
          _ => null,
        };
      }''';
    }).join('\n\n');
  }

  ({String parameters, String cases}) _createMatchComponents(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final parameters = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final paramType = classInfo.hasMember
          ? '${e}${classInfo.genericsSuffix} data'
          : '$e data';
      return 'required R Function($paramType) ${e.toCamelCase()}';
    }).join(',\n');

    final cases = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final thisType = classInfo.hasMember
          ? 'this as ${e}${classInfo.genericsSuffix}'
          : 'this as $e';
      return '${e}${classInfo.genericsSuffix}() => ${e.toCamelCase()}($thisType),';
    }).join('\n');

    return (parameters: parameters, cases: cases);
  }

  ({String parameters, String cases}) _createMatchOrElseComponents(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final parameters = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final paramType = classInfo.hasMember
          ? '${e}${classInfo.genericsSuffix} data'
          : '$e data';
      return 'R Function($paramType)? ${e.toCamelCase()}';
    }).join(',\n');

    final cases = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final thisType = classInfo.hasMember
          ? 'this as ${e}${classInfo.genericsSuffix}'
          : 'this as $e';
      return '${e}${classInfo.genericsSuffix}() => ${e.toCamelCase()} == null ? orElse($thisType) : ${e.toCamelCase()}($thisType),';
    }).join('\n');

    return (parameters: parameters, cases: cases);
  }

  ({String parameters, String cases}) _createMaybeMatchComponents(
    String className,
    List<String> subClasses,
    GeneratorHelper helper,
  ) {
    final parameters = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final paramType = classInfo.hasMember
          ? '${e}${classInfo.genericsSuffix} data'
          : '$e data';
      return 'R Function($paramType)? ${e.toCamelCase()}';
    }).join(',\n');

    final cases = subClasses.map((e) {
      final classInfo = _getClassInfo(e, className, helper);
      final thisType = classInfo.hasMember
          ? 'this as ${e}${classInfo.genericsSuffix}'
          : 'this as $e';
      return '${e}${classInfo.genericsSuffix}() => ${e.toCamelCase()}?.call($thisType),';
    }).join('\n');

    return (parameters: parameters, cases: cases);
  }

  ({bool hasMember, String genericsSuffix}) _getClassInfo(
    String subClass,
    String className,
    GeneratorHelper helper,
  ) {
    final fullClassContent = _openCloseFinder.run(
      helper.sourceCodeContent,
      helper.isFreezed ? className : subClass,
    );

    final hasMember = helper.isFreezed
        ? !fullClassContent.contains("factory $className.$subClass()")
        : (fullClassContent.contains("final ") ||
            fullClassContent.contains("super."));

    final genericsType = helper.getGenericsType(className);
    final genericsSuffix = genericsType.isEmpty ? '' : '<$genericsType>';

    return (hasMember: hasMember, genericsSuffix: genericsSuffix);
  }
}
