import 'package:fp_state_generator/fp_state_annotation.dart';
part 'result.fpState.dart';

@fpState
sealed class Result<T> {}

class ResultSuccess<T> extends Result<T> {
  final T? data;
  ResultSuccess(this.data);
  @override
  String toString() {
    return 'ResultSuccess { data : $data }';
  }
}

class ResultFailed<T> extends Result<T> {
  final Object? error;
  ResultFailed(this.error);
  @override
  String toString() {
    return 'ResultFailed { error : $error }';
  }
}
