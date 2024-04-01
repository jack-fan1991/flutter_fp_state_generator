import 'package:fp_state_generator/fp_state_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'main.fpState.dart';
part 'main.freezed.dart';

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

@fpState
class UiState {}

class LState extends UiState {}

class RState extends UiState {}

class R3State extends UiState {}

class R4State extends UiState {}

@freezed
@fpState
sealed class FreezedState with _$FreezedState {
  const FreezedState._();
  const factory FreezedState.FreezedState(final String user) = FreezedState1;
  const factory FreezedState.FreezedState2(final String user, final String id) =
      FreezedState2;
  const factory FreezedState.FreezedState3(
      final String user, final bool activate) = FreezedState3;
}

void main(List<String> args) {
  final state = LState();
  final match = state.match(
    lState: (data) => "LState",
    rState: (data) => "FState",
    r3State: (R3State data) {},
    r4State: (R4State data) {},
  );
  // match => "LState"
  final matchOrElse = state.matchOrElse(
    rState: (data) => "FState",
    r3State: (R3State data) {},
    r4State: (R4State data) {},
    orElse: (data) => "Orlese result",
  );
  //  matchOrElse => "Orlese result"

  final maybeMatch = state.maybeMatch(
    rState: (data) => "FState",
    r3State: (R3State data) {},
    r4State: (R4State data) {},
  );

  // maybeMatch = null

  final freezedState = FreezedState.FreezedState2("jack", "1");
  final freezedMatch = freezedState.match(
    freezedState1: (data) => "FreezedState",
    freezedState2: (data) => "FreezedState2 ${data.user},${data.id} ",
    freezedState3: (data) => "FreezedState3",
  );
  // freezedMatch => "FreezedState2 jack,1 "

  final freezedMatchOrElse = freezedState.matchOrElse(
    freezedState1: (data) => "FreezedState",
    freezedState3: (data) => "FreezedState3",
    orElse: (data) => "OrElse result",
  );
  // freezedMatchOrElse => "OrElse result"

  final freezedMaybeMatch = freezedState.maybeMatch(
    freezedState1: (data) => "FreezedState",
    freezedState3: (data) => "FreezedState3",
  );
  // freezedMaybeMatch => null

  final asyncState = AsyncLoaded(data: "data");
  final asyncMatch = asyncState.match(
    asyncLoading: (data) => "AsyncLoading",
    asyncLoaded: (data) => "AsyncLoaded ${data.data}",
  );
  // asyncMatch => "AsyncLoaded data"

  final asyncMatchOrElse = asyncState.matchOrElse(
    asyncLoading: (data) => "AsyncLoading",
    asyncLoaded: (data) => "AsyncLoaded ${data.data}",
    orElse: (data) => "OrElse result",
  );
  // asyncMatchOrElse => "AsyncLoaded data"

  final asyncMaybeMatch = asyncState.maybeMatch(
    asyncLoading: (data) => "AsyncLoading",
  );
  // asyncMaybeMatch => null
}
