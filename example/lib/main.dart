import 'package:fp_state_generator/fp_state_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'main.freezed.dart';
part 'main.fpState.dart';

@fpState
class UiState {}

class LState extends UiState {}

class RState extends UiState {}

class R3State extends UiState {}

class MemberState extends UiState {
  final String user;
  MemberState(this.user);
}

@freezed
@fpState
sealed class FreezedState with _$FreezedState {
  const FreezedState._();
  const factory FreezedState.NoMember() = NoMember;
  const factory FreezedState.FreezedState(final String user) = FreezedState1;
  const factory FreezedState.FreezedState2(final String user, final String id) =
      FreezedState2;
  const factory FreezedState.FreezedState3(
      final String user, final bool activate) = FreezedState3;
}
