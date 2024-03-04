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
  Future<String> get sourceCodeContent => getFileContent();

  Future<String> getFileContent() async {
    final sourceCodePath = buildStep.inputId.path;
    // 读取文件内容
    var fileContent = await File(sourceCodePath).readAsString();
    print('==========');
    print(fileContent);
    print('==========');
    return fileContent;
  }

  String testCode(
      Element element, ConstantReader annotation, BuildStep buildStep) {
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
    var sourceCodePath = buildStep.inputId.path;

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
