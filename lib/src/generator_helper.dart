import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class GeneratorHelper {
  final Element element;
  final ConstantReader annotation;
  final BuildStep buildStep;
  GeneratorHelper(this.element, this.annotation, this.buildStep);

  String get annotationSourceCode =>
      element.source?.contents.data ?? "No source code available";
  String get className => element.displayName;
  String get sourceCodePath => buildStep.inputId.path;
  String get sourceCodeFileName =>
      sourceCodePath.split('/').last.replaceAll('.dart', '');
  String get baseFileName =>
      sourceCodePath.split('/').last.replaceAll('.dart', '');
  String get expectPartFileName => "part '$baseFileName.fpState.dart';";

  Future<String> get sourceCodeContent => getFileContent();

  String get genericsType {
    final pattern = RegExp('class\\s+$className(?:<(.*?)>)?');
    // print('------------- ');
    // print("r'class\s+$className(?:<(.*?)>)?'");
    final r = pattern
        .allMatches(annotationSourceCode)
        .map((e) => e.group(1))
        .toList();
    if (r.first == null) {
      return '';
    }

    // print("$r");
    if (r.isEmpty) return '';
    final type =
        pattern.allMatches(annotationSourceCode).map((e) => e.group(1)!).first;
    // print(type);
    return type;
  }

  Future<String> getFileContent() async {
    final sourceCodePath = buildStep.inputId.path;
    // 读取文件内容
    var fileContent = await File(sourceCodePath).readAsString();
    // print('==========');
    // print(fileContent);
    // print('==========');
    return fileContent;
  }

  Future<void> fixPartImportContent() async {
    final sourceCode = await sourceCodeContent;
    print(expectPartFileName);
    if (sourceCode.contains(expectPartFileName)) return;
    final lastImportIdx =
        await findLastImportIdx(expectPartFileName, sourceCode);
    File file = File(sourceCodePath);
    List<String> newCode = sourceCode.split(RegExp(r'\r?\n'));
    newCode.insert(lastImportIdx, expectPartFileName);
    // print('---------------');

    // print(newCode.join('\n'));
    file.readAsString().then((String contents) {
      file.writeAsString(newCode.join('\n')).then((_) async {
        print(
            'Fix import line $expectPartFileName [Line : ${lastImportIdx + 1}]   success');
        print('Place run command : flutter pub run build_runner build');
        exit(0);
      });
    }).catchError((error) {
      print('file read error ：$error');
    });
    return;
  }

  Future<int> findLastImportIdx(String insertText, String sourceCode) async {
    List<String> lines = sourceCode.split(RegExp(r'\r?\n'));
    int linesCount = lines.length;
    int insertIdx = 0;
    int firstPartLineIdx = -1;
    bool hasPartImport = false;

    for (int lIdx = 0; lIdx < linesCount; lIdx++) {
      String line = lines[lIdx];
      hasPartImport = hasPartImport || line.startsWith('part');

      if (line.startsWith('import') || line.startsWith('part')) {
        insertIdx++;
        continue;
      }

      if (line == '') {
        int tryCount = 0;
        for (int i = lIdx + 1; i < lines.length - lIdx; i++) {
          tryCount++;
          String nextLine = lines[i];

          if (firstPartLineIdx < 0 && nextLine.startsWith('part')) {
            firstPartLineIdx = i;
          }

          hasPartImport = hasPartImport || nextLine.startsWith('part');
          if (nextLine.startsWith('import') || nextLine.startsWith('part')) {
            insertIdx = i;
            break;
          }
          if (tryCount > 10) {
            lIdx = 99999;
            break;
          }
        }
      }
    }

    if (insertText.startsWith('import')) {
      insertIdx = hasPartImport ? firstPartLineIdx : insertIdx;
    } else {
      insertIdx = insertIdx < 0 ? 0 : insertIdx;
    }
    return insertIdx < 0 ? 0 : insertIdx;
  }

  String testCode() {
    final kind = element.kind;

    final className = element.displayName;
    final param = annotation.peek("name")?.stringValue ?? "Unknown";
    final ana = annotation.runtimeType;
    final sourceCode =
        element.source?.contents.data ?? "No source code available";
    //filePath -> /example/lib/data.dart
    final filePath = element.source!.fullName;
    //relPath -> data.dart ,
    final relPath = element.source!.shortName;
    //package:example/data.dart
    final uri = element.source!.uri;
    // var sourceCodePath = buildStep.inputId.path;

    return '''
    type -> $kind
      className -> $className,
      annotation -> $ana,
      annotationParam -> $param ,
      sourceCode ->  $sourceCode ,
      filePath -> $filePath ,
      relPath -> $relPath ,
      uri -> $uri
     
      ''';
  }
}
