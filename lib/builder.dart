import 'package:build/build.dart';
import 'package:fp_state_generator/src/fp_state_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder fpStateBuilder(BuilderOptions options) =>
    PartBuilder([FpStateGenerator()], '.fp_state.dart');
