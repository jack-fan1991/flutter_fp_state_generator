// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPResult<T> on Result<T> {
  R match<R>({
    required R Function(ResultSuccess<T> data) resultSuccess,
    required R Function(ResultFailed<T> data) resultFailed,
    R Function(Result<T> data)? result,
  }) {
    final r = switch (this) {
      ResultSuccess<T>() => resultSuccess(this as ResultSuccess<T>),
      ResultFailed<T>() => resultFailed(this as ResultFailed<T>),
      Result<T>() => result?.call(this),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function(ResultSuccess<T> data)? resultSuccess,
    R Function(ResultFailed<T> data)? resultFailed,
    required R Function(Result data) orElse,
  }) {
    final r = switch (this) {
      ResultSuccess<T>() => resultSuccess == null
          ? orElse(this as ResultSuccess<T>)
          : resultSuccess(this as ResultSuccess<T>),
      ResultFailed<T>() => resultFailed == null
          ? orElse(this as ResultFailed<T>)
          : resultFailed(this as ResultFailed<T>),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function(ResultSuccess<T> data)? resultSuccess,
    R Function(ResultFailed<T> data)? resultFailed,
  }) {
    final r = switch (this) {
      ResultSuccess<T>() => resultSuccess?.call(this as ResultSuccess<T>),
      ResultFailed<T>() => resultFailed?.call(this as ResultFailed<T>),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
