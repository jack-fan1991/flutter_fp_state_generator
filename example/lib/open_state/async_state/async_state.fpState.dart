// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_state.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPAsyncState<T> on AsyncState<T> {
  R match<R>({
    required R Function() asyncLoading,
    required R Function(AsyncLoaded<T> data) asyncLoaded,
    required R Function(AsyncFailed<T> data) asyncFailed,
  }) {
    final r = switch (this) {
      AsyncLoading<T>() => asyncLoading(),
      AsyncLoaded<T>() => asyncLoaded(this as AsyncLoaded<T>),
      AsyncFailed<T>() => asyncFailed(this as AsyncFailed<T>),
      AsyncState() => throw Exception("$runtimeType not match"),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function()? asyncLoading,
    R Function(AsyncLoaded<T> data)? asyncLoaded,
    R Function(AsyncFailed<T> data)? asyncFailed,
    required R Function(AsyncState data) orElse,
  }) {
    final r = switch (this) {
      AsyncLoading<T>() =>
        asyncLoading == null ? orElse(this as AsyncLoading<T>) : asyncLoading(),
      AsyncLoaded<T>() => asyncLoaded == null
          ? orElse(this as AsyncLoaded<T>)
          : asyncLoaded(this as AsyncLoaded<T>),
      AsyncFailed<T>() => asyncFailed == null
          ? orElse(this as AsyncFailed<T>)
          : asyncFailed(this as AsyncFailed<T>),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function()? asyncLoading,
    R Function(AsyncLoaded<T> data)? asyncLoaded,
    R Function(AsyncFailed<T> data)? asyncFailed,
  }) {
    final r = switch (this) {
      AsyncLoading<T>() => asyncLoading?.call(),
      AsyncLoaded<T>() => asyncLoaded?.call(this as AsyncLoaded<T>),
      AsyncFailed<T>() => asyncFailed?.call(this as AsyncFailed<T>),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
