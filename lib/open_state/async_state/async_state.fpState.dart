// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_state.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPAsyncState on AsyncState {
  R match<R>({
    required R Function() asyncLoading,
    required R Function(AsyncLoaded data) asyncLoaded,
    required R Function(AsyncFailed data) asyncFailed,
  }) {
    final r = switch (this) {
      AsyncLoading() => asyncLoading(),
      AsyncLoaded() => asyncLoaded(this as AsyncLoaded),
      AsyncFailed() => asyncFailed(this as AsyncFailed),
      AsyncState() => throw Exception("$runtimeType not match"),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function()? asyncLoading,
    R Function(AsyncLoaded data)? asyncLoaded,
    R Function(AsyncFailed data)? asyncFailed,
    required R Function(AsyncState data) orElse,
  }) {
    final r = switch (this) {
      AsyncLoading() =>
        asyncLoading == null ? orElse(this as AsyncLoading) : asyncLoading(),
      AsyncLoaded() => asyncLoaded == null
          ? orElse(this as AsyncLoaded)
          : asyncLoaded(this as AsyncLoaded),
      AsyncFailed() => asyncFailed == null
          ? orElse(this as AsyncFailed)
          : asyncFailed(this as AsyncFailed),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function()? asyncLoading,
    R Function(AsyncLoaded data)? asyncLoaded,
    R Function(AsyncFailed data)? asyncFailed,
  }) {
    final r = switch (this) {
      AsyncLoading() => asyncLoading?.call(),
      AsyncLoaded() => asyncLoaded?.call(this as AsyncLoaded),
      AsyncFailed() => asyncFailed?.call(this as AsyncFailed),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
