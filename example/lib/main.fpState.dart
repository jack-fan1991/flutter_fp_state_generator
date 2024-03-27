// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPUiState on UiState {
  R match<R>({
    required R Function(LState data) lState,
    required R Function(RState data) rState,
    required R Function(R3State data) r3State,
    required R Function(R4State data) r4State,
  }) {
    final r = switch (this) {
      LState() => lState(this as LState),
      RState() => rState(this as RState),
      R3State() => r3State(this as R3State),
      R4State() => r4State(this as R4State),
      UiState() => throw Exception("$runtimeType not match"),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function(LState data)? lState,
    R Function(RState data)? rState,
    R Function(R3State data)? r3State,
    R Function(R4State data)? r4State,
    required R Function(UiState data) orElse,
  }) {
    final r = switch (this) {
      LState() =>
        lState == null ? orElse(this as LState) : lState(this as LState),
      RState() =>
        rState == null ? orElse(this as RState) : rState(this as RState),
      R3State() =>
        r3State == null ? orElse(this as R3State) : r3State(this as R3State),
      R4State() =>
        r4State == null ? orElse(this as R4State) : r4State(this as R4State),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function(LState data)? lState,
    R Function(RState data)? rState,
    R Function(R3State data)? r3State,
    R Function(R4State data)? r4State,
  }) {
    final r = switch (this) {
      LState() => lState?.call(this as LState),
      RState() => rState?.call(this as RState),
      R3State() => r3State?.call(this as R3State),
      R4State() => r4State?.call(this as R4State),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}

extension FPFreezedState on FreezedState {
  R match<R>({
    required R Function(FreezedState1 data) freezedState1,
    required R Function(FreezedState2 data) freezedState2,
    required R Function(FreezedState3 data) freezedState3,
  }) {
    final r = switch (this) {
      FreezedState1() => freezedState1(this as FreezedState1),
      FreezedState2() => freezedState2(this as FreezedState2),
      FreezedState3() => freezedState3(this as FreezedState3),
      FreezedState() => throw Exception("$runtimeType not match"),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function(FreezedState1 data)? freezedState1,
    R Function(FreezedState2 data)? freezedState2,
    R Function(FreezedState3 data)? freezedState3,
    required R Function(FreezedState data) orElse,
  }) {
    final r = switch (this) {
      FreezedState1() => freezedState1 == null
          ? orElse(this as FreezedState1)
          : freezedState1(this as FreezedState1),
      FreezedState2() => freezedState2 == null
          ? orElse(this as FreezedState2)
          : freezedState2(this as FreezedState2),
      FreezedState3() => freezedState3 == null
          ? orElse(this as FreezedState3)
          : freezedState3(this as FreezedState3),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function(FreezedState1 data)? freezedState1,
    R Function(FreezedState2 data)? freezedState2,
    R Function(FreezedState3 data)? freezedState3,
  }) {
    final r = switch (this) {
      FreezedState1() => freezedState1?.call(this as FreezedState1),
      FreezedState2() => freezedState2?.call(this as FreezedState2),
      FreezedState3() => freezedState3?.call(this as FreezedState3),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
