import 'package:build/build.dart';
import 'package:fp_state_generator/src/fp_state_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Returns a [Builder] for generating Flutter FP state files.
///
/// The [options] parameter is used to configure the builder.
/// This builder uses the [FpStateGenerator] to generate the state files.
/// The generated files will have the extension '.fp_state.dart'.
Builder fpStateBuilder(BuilderOptions options) =>
    PartBuilder([FpStateGenerator()], '.fp_state.dart');
