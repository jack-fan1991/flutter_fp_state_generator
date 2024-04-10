import 'package:fp_state_generator/fp_state_annotation.dart';
part 'async_state.fpState.dart';

@fpState
sealed class AsyncState<T> {
  const AsyncState();
}

class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

class AsyncLoaded<T> extends AsyncState<T> {
  final T data;
  const AsyncLoaded({required this.data});
  @override
  String toString() => "AsyncLoaded { data : $data }";
}

class AsyncFailed<T> extends AsyncState<T> {
  final Object? error;
  const AsyncFailed(this.error);
  @override
  String toString() => "AsyncFailed { error : $error }";
}
