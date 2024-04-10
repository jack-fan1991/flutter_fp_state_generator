// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPResult on Result {
  R match<R>({
    required R Function(ResultSuccess data) resultSuccess,
    required R Function(ResultFailed data) resultFailed,
  }) {
    final r = switch (this) {
      ResultSuccess() => resultSuccess(this as ResultSuccess),
      ResultFailed() => resultFailed(this as ResultFailed),
      Result() => throw Exception("$runtimeType not match"),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function(ResultSuccess data)? resultSuccess,
    R Function(ResultFailed data)? resultFailed,
    required R Function(Result data) orElse,
  }) {
    final r = switch (this) {
      ResultSuccess() => resultSuccess == null
          ? orElse(this as ResultSuccess)
          : resultSuccess(this as ResultSuccess),
      ResultFailed() => resultFailed == null
          ? orElse(this as ResultFailed)
          : resultFailed(this as ResultFailed),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function(ResultSuccess data)? resultSuccess,
    R Function(ResultFailed data)? resultFailed,
  }) {
    final r = switch (this) {
      ResultSuccess() => resultSuccess?.call(this as ResultSuccess),
      ResultFailed() => resultFailed?.call(this as ResultFailed),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
