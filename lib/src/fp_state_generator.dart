import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:fp_state_generator/fp_state_annotation.dart';
import 'package:fp_state_generator/src/generator_helper.dart';
import 'package:source_gen/source_gen.dart';

class FpStateGenerator extends GeneratorForAnnotation<FpState> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final generatorHelper = GeneratorHelper(element, annotation, buildStep);
    final className = generatorHelper.className;
    final subClassName =
        getSubClasses(generatorHelper.annotationSourceCode, className);
    final result = '''
    extension FP${element.displayName} on ${element.displayName} {
      ${createMatch(className, subClassName)}

      ${createMatchOrElse(className, subClassName)}
      
      ${createMaybeMatch(className, subClassName)}
      
    }


''';
    // await generatorHelper.getFileContent();

    return result;
  }

  String createMatch(
    String className,
    List<String> subClassName,
  ) {
    final params = subClassName
        .map((e) => 'required R Function($e data) ${e.toCamelCase()}')
        .join(',\n');
    final cases = subClassName
        .map((e) => '$e() => ${e.toCamelCase()}(this as $e),')
        .join('\n');

    return '''
R match<R>({
    $params,
  }) {
    final r = switch (this) {
      $cases
      $className() => throw Exception("\$runtimeType not match"),
    };
    return r;
} 
''';
  }

  String createMatchOrElse(
    String className,
    List<String> subClassName,
  ) {
    final params = subClassName
        .map((e) => 'R Function($e data)? ${e.toCamelCase()}')
        .join(',\n');
    final cases = subClassName
        .map((e) =>
            '$e() =>${e.toCamelCase()}==null? orElse(this as $e): ${e.toCamelCase()}(this as $e),')
        .join('\n');

    return '''
R matchOrElse<R>({
    $params,
    required R Function($className data) orElse,
  }) {
    final r = switch (this) {
      $cases
      _ => orElse(this),
    };
    return r;
} 
''';
  }

  String createMaybeMatch(
    String className,
    List<String> subClassName,
  ) {
    final params = subClassName
        .map((e) => 'R Function($e data)? ${e.toCamelCase()}')
        .join(',\n');
    final cases = subClassName
        .map((e) => '$e() => ${e.toCamelCase()}?.call(this as $e),')
        .join('\n');
    return '''
R? maybeMatch<R>({
    $params,
  }) {
    final r = switch (this) {
      $cases
      _ => throw Exception("\$runtimeType not match"),
    };
    return r;
} 
''';
  }

  bool isSealedClass(String sourceCode) {
    final pattern = RegExp(r'sealed\s+class\s+(\w+)\s*{');
    return pattern.hasMatch(sourceCode);
  }

  List<String> getSubClasses(String sourceCode, String className) {
    final pattern = RegExp('class\\s+(\\w+)\\s+extends\\s+$className');
    return pattern.allMatches(sourceCode).map((e) => e.group(1)!).toList();
  }
}
