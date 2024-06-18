// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPTaskListCacheModel<T> on TaskListCacheModel<T> {
  R match<R>({
    required R Function() taskListCacheAddListButton,
    R Function(TaskListCacheModel<T> data)? taskListCacheModel,
  }) {
    final r = switch (this) {
      TaskListCacheAddListButton<T>() => taskListCacheAddListButton(),
      TaskListCacheModel<T>() => taskListCacheModel?.call(this),
    };
    if(r == null){
      t
    }
    return r;
  }

  R matchOrElse<R>({
    R Function()? taskListCacheAddListButton,
    required R Function(TaskListCacheModel data) orElse,
  }) {
    final r = switch (this) {
      TaskListCacheAddListButton() => taskListCacheAddListButton == null
          ? orElse(this as TaskListCacheAddListButton)
          : taskListCacheAddListButton(),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function()? taskListCacheAddListButton,
  }) {
    final r = switch (this) {
      TaskListCacheAddListButton<T>() => taskListCacheAddListButton?.call(),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
