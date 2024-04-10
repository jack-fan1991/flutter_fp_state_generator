import 'package:example/open_state/async_state/async_state.dart';
import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test State ', () {
    final state = LState();
    final match = state.match(
      lState: () => "LState",
      rState: () => "FState",
      r3State: () {},
      memberState: (MemberState data) {},
    );
    // match => "LState"
    print(match);
    expect(match, "LState");

    final matchOrElse = state.matchOrElse(
      rState: () => "rState",
      r3State: () {},
      orElse: (data) => "No implement lState so call OrElse",
    );
    expect(matchOrElse, "No implement lState so call OrElse");

    final maybeMatch = state.maybeMatch(
      rState: () => "rState",
      r3State: () {},
      memberState: (MemberState data) {},
    );
    // No implement lState so return null
    expect(maybeMatch, null);
  });

  test('test freezed State ', () {
    final freezedState = FreezedState.FreezedState2("jack", "1");

    final freezedMatch = freezedState.match(
      freezedState1: (data) => "FreezedState",
      freezedState2: (data) => "FreezedState2 ${data.user},${data.id} ",
      freezedState3: (data) => "FreezedState3",
      noMember: () {},
    );
    expect(freezedMatch, "FreezedState2 jack,1 ");

    final freezedMatchOrElse = freezedState.matchOrElse(
      freezedState1: (data) => "FreezedState",
      freezedState3: (data) => "FreezedState3",
      orElse: (data) => "No implement FreezedState2 so call OrElse",
    );
    expect(freezedMatchOrElse, "No implement FreezedState2 so call OrElse");

    final freezedMaybeMatch = freezedState.maybeMatch(
      freezedState1: (data) => "FreezedState",
      freezedState3: (data) => "FreezedState3",
    );
    // No implement FreezedState2 so return null
    expect(freezedMaybeMatch, null);
  });

  test('test asyncState', () {
    final asyncState = AsyncLoaded(data: "data");
    final asyncMatch = asyncState.match(
      asyncLoading: () => "AsyncLoading",
      asyncLoaded: (data) => "AsyncLoaded ${data.data}",
      asyncFailed: (AsyncFailed<dynamic> data) {},
    );
    // asyncMatch => "AsyncLoaded data"
    expect(asyncMatch, "AsyncLoaded data");

    final asyncMatchOrElse = asyncState.matchOrElse(
      asyncLoading: () => "AsyncLoading",
      orElse: (data) => "No implement asyncLoaded so call OrElse",
    );

    expect(asyncMatchOrElse, "No implement asyncLoaded so call OrElse");

    final asyncMaybeMatch = asyncState.maybeMatch(
      asyncLoading: () => "AsyncLoading",
    );
    // No implement asyncLoaded so return null
    expect(asyncMaybeMatch, null);
  });
}
