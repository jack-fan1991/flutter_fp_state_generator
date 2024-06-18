// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// FpStateGenerator
// **************************************************************************

extension FPUiState on UiState {
  R match<R>({
    required R Function() lState,
    required R Function() rState,
    required R Function() r3State,
    required R Function(MemberState data) memberState,
    R Function(UiState data)? uiState,
  }) {
    final r = switch (this) {
      LState() => lState(),
      RState() => rState(),
      R3State() => r3State(),
      MemberState() => memberState(this as MemberState),
      UiState() => uiState?.call(this),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function()? lState,
    R Function()? rState,
    R Function()? r3State,
    R Function(MemberState data)? memberState,
    required R Function(UiState data) orElse,
  }) {
    final r = switch (this) {
      LState() => lState == null ? orElse(this as LState) : lState(),
      RState() => rState == null ? orElse(this as RState) : rState(),
      R3State() => r3State == null ? orElse(this as R3State) : r3State(),
      MemberState() => memberState == null
          ? orElse(this as MemberState)
          : memberState(this as MemberState),
      _ => orElse(this),
    };
    return r;
  }

  R? maybeMatch<R>({
    R Function()? lState,
    R Function()? rState,
    R Function()? r3State,
    R Function(MemberState data)? memberState,
  }) {
    final r = switch (this) {
      LState() => lState?.call(),
      RState() => rState?.call(),
      R3State() => r3State?.call(),
      MemberState() => memberState?.call(this as MemberState),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}

extension FPFreezedState on FreezedState {
  R match<R>({
    required R Function() noMember,
    required R Function(FreezedState1 data) freezedState1,
    required R Function(FreezedState2 data) freezedState2,
    required R Function(FreezedState3 data) freezedState3,
  }) {
    final r = switch (this) {
      NoMember() => noMember(),
      FreezedState1() => freezedState1(this as FreezedState1),
      FreezedState2() => freezedState2(this as FreezedState2),
      FreezedState3() => freezedState3(this as FreezedState3),
      FreezedState() => freezedState?.call(this),
    };
    return r;
  }

  R matchOrElse<R>({
    R Function()? noMember,
    R Function(FreezedState1 data)? freezedState1,
    R Function(FreezedState2 data)? freezedState2,
    R Function(FreezedState3 data)? freezedState3,
    required R Function(FreezedState data) orElse,
  }) {
    final r = switch (this) {
      NoMember() => noMember == null ? orElse(this as NoMember) : noMember(),
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
    R Function()? noMember,
    R Function(FreezedState1 data)? freezedState1,
    R Function(FreezedState2 data)? freezedState2,
    R Function(FreezedState3 data)? freezedState3,
  }) {
    final r = switch (this) {
      NoMember() => noMember?.call(),
      FreezedState1() => freezedState1?.call(this as FreezedState1),
      FreezedState2() => freezedState2?.call(this as FreezedState2),
      FreezedState3() => freezedState3?.call(this as FreezedState3),
      _ => throw Exception("$runtimeType not match"),
    };
    return r;
  }
}
