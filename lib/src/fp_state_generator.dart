/// ignore freezed
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:change_case/change_case.dart';
import 'package:fp_state_generator/fp_state_annotation.dart';
import 'package:fp_state_generator/src/generator_helper.dart';
import 'package:fp_state_generator/src/open_close_finder.dart';

import 'package:source_gen/source_gen.dart';

class FpStateGenerator extends GeneratorForAnnotation<FpState> {
  final Map<String, int> cache = {};
  final BigOpenCloseFinder bigOpenCloseFinder = BigOpenCloseFinder();

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final generatorHelper =
        await GeneratorHelper(element, annotation, buildStep)
          ..getFileContent();
    // print(generatorHelper.testCode());
    // print(generatorHelper.genericsType);

    // print('----');
    final className = generatorHelper.className;

    final genericsType = generatorHelper.getGenericsType(className);
    // print('====>  $genericsType');

    // print(generatorHelper.expectPartFileName);
    await generatorHelper.fixPartImportContent();

    // print(generatorHelper.sourceCodeContent);
    generatorHelper.isFreezed = isClassFreezed(generatorHelper);
    // print('====>  $className , is freezed => $isFreezed ');
    List<String> subClassName = [];
    if (generatorHelper.isFreezed) {
      final result = freezedSubNameOrNull(generatorHelper);
      if (result == null) {
        // print('====> !!!');
        return "";
      }
      subClassName = result;
    } else {
      subClassName =
          getSubClasses(generatorHelper.annotationSourceCode, className);
    }

    // print('====> $subClassName');
    String displayName = element.displayName;
    if (genericsType.isNotEmpty) {
      displayName = '$displayName<$genericsType>';
    }

    final content = '''
    extension FP${displayName} on ${displayName} {
      ${createMatch(className, subClassName, generatorHelper)}

      ${createMatchOrElse(className, subClassName, generatorHelper)}
      
      ${createMaybeMatch(className, subClassName, generatorHelper)}
      
    }


''';
    // await generatorHelper.getFileContent();
    // print(className);
    // print('====> !!! $content');

    return content;
  }

  bool isClassFreezed(GeneratorHelper generatorHelper) {
    final lines = generatorHelper.annotationSourceCode.split('\n');
    final className = generatorHelper.className;
    int idx = 0;
    for (final l in lines) {
      if (l.contains('class $className')) {
        idx = lines.indexOf(l);
        // print(
        //     '===> $l  contains class $className ${l.contains('class $className')}');

        bool isFreezed = false;
        String targetLine = '';
        while (!targetLine.contains('}') && idx > 0) {
          idx--;
          targetLine = lines.elementAt(idx);
          // print('===> target line  $targetLine ');
          if (targetLine.contains("@Freezed") ||
              targetLine.contains('@freezed')) {
            isFreezed = true;
            cache[className] = idx;
            break;
          }
        }
        return isFreezed;
      }
    }
    return false;
  }

  List<String>? freezedSubNameOrNull(GeneratorHelper generatorHelper) {
    final className = generatorHelper.className;

    final classLineStart = cache[className];
    if (classLineStart == null) {
      return null;
    }
    final freezedClassLine = generatorHelper.annotationSourceCode
        .split('\n')
        .sublist(classLineStart);

    // print('====>start freezedSubNameOrNull ${freezedClassLine.join()}=====');
    List<String> subClassName = [];
    int idx = 0;

    for (final l in freezedClassLine) {
      if (l.startsWith('}')) {
        break;
      }
      if (l.contains('=')) {
        String sub = '';
        if (l.endsWith('=')) {
          sub = freezedClassLine.toList()[idx + 1].replaceAll(';', '');
        } else {
          sub = l.split('=').last.trim().replaceAll(';', '');
        }

        // print(sub);
        subClassName.add(sub);
      }
      idx++;
    }
    return subClassName.isEmpty ? null : subClassName;
  }

  String createMatch(
    String className,
    List<String> subClassName,
    GeneratorHelper generatorHelper,
  ) {
    final params = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );
      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");
      final genericsType = generatorHelper.getGenericsType(className);
      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? '$e$endFix data' : '';
      return 'required R Function($callBackName) ${e.toCamelCase()}';
    }).join(',\n');
    final cases = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );
      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");
      final genericsType = generatorHelper.getGenericsType(className);
      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? 'this as $e$endFix' : '';
      return '$e$endFix() => ${e.toCamelCase()}($callBackName),';
    }).join('\n');

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
    GeneratorHelper generatorHelper,
  ) {
    final params = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );

      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");

      final genericsType = generatorHelper.getGenericsType(e);

      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? '$e$endFix data' : '';

      return 'R Function($callBackName)? ${e.toCamelCase()}';
    }).join(',\n');
    final cases = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );
      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");
      final genericsType = generatorHelper.getGenericsType(e);
      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? 'this as $e$endFix' : '';
      return '$e$endFix() =>${e.toCamelCase()}==null? orElse(this as $e$endFix): ${e.toCamelCase()}($callBackName),';
    }).join('\n');

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
    GeneratorHelper generatorHelper,
  ) {
    final params = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );
      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");
      final genericsType = generatorHelper.getGenericsType(e);
      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? '$e$endFix data' : '';
      return 'R Function($callBackName)? ${e.toCamelCase()}';
    }).join(',\n');
    final cases = subClassName.map((e) {
      final fullClassContent = bigOpenCloseFinder.run(
        generatorHelper.sourceCodeContent,
        generatorHelper.isFreezed ? className : e,
      );
      final isClassHasMember = generatorHelper.isFreezed
          ? fullClassContent.contains("factory $className.${e}()") == false
          : fullClassContent.contains("final ");
      final genericsType = generatorHelper.getGenericsType(className);
      final endFix = genericsType.isEmpty ? '' : '<$genericsType>';
      final callBackName = isClassHasMember ? 'this as $e$endFix' : '';
      return '$e$endFix () => ${e.toCamelCase()}?.call($callBackName),';
    }).join('\n');
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
    final pattern =
        RegExp('class\\s+(\\w+)(?:<\\w*>)?\\s+extends\\s+$className');
    final classes =
        pattern.allMatches(sourceCode).map((e) => e.group(1)!).toList();
    return classes.isEmpty ? [className] : classes;
  }
}
