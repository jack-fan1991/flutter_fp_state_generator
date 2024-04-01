import 'dart:math';

import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test State ', () {
    final state = LState();
    final match = state.match(
      lState: (data) => "LState",
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
    );
    // match => "LState"
    print(match);
    expect(match, "LState");

    final matchOrElse = state.matchOrElse(
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
      orElse: (data) => "OrElse result",
    );
    expect(matchOrElse, "OrElse result");
    final maybeMatch = state.maybeMatch(
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
    );
    expect(maybeMatch, null);
  });

  test('test freezed State ', () {
    final freezedState = FreezedState.FreezedState2("jack", "1");

    final freezedMatch = freezedState.match(
      freezedState1: (data) => "FreezedState",
      freezedState2: (data) => "FreezedState2 ${data.user},${data.id} ",
      freezedState3: (data) => "FreezedState3",
    );
    expect(freezedMatch, "FreezedState2 jack,1 ");

    final freezedMatchOrElse = freezedState.matchOrElse(
      freezedState1: (data) => "FreezedState",
      freezedState3: (data) => "FreezedState3",
      orElse: (data) => "OrElse result",
    );
    expect(freezedMatchOrElse, "OrElse result");

    final freezedMaybeMatch = freezedState.maybeMatch(
      freezedState1: (data) => "FreezedState",
      freezedState3: (data) => "FreezedState3",
    );
    expect(freezedMaybeMatch, null);
  });

  test('test asyncState', () {
    final asyncState = AsyncLoaded(data: "data");
    final asyncMatch = asyncState.match(
      asyncLoading: (data) => "AsyncLoading",
      asyncLoaded: (data) => "AsyncLoaded ${data.data}",
    );
    // asyncMatch => "AsyncLoaded data"
    expect(asyncMatch, "AsyncLoaded data");

    final asyncMatchOrElse = asyncState.matchOrElse(
      asyncLoading: (data) => "AsyncLoading",
      asyncLoaded: (data) => "AsyncLoaded ${data.data}",
      orElse: (data) => "OrElse result",
    );
    // asyncMatchOrElse => "AsyncLoaded data"
    expect(asyncMatchOrElse, "AsyncLoaded data");

    final asyncMaybeMatch = asyncState.maybeMatch(
      asyncLoading: (data) => "AsyncLoading",
    );
    // asyncMaybeMatch => null
    expect(asyncMaybeMatch, null);
  });
}
