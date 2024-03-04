import 'package:example/test_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testName ', () {
    final state = LState();
    final match = state.match(
      lState: (data) => "LState",
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
    );
    // match => "LState"
    print(match);

    final matchOrElse = state.matchOrElse(
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
      orElse: (data) => "OrElse result",
    );
    //  matchOrElse => "OrElse result"
    print(matchOrElse);
    final maybeMatch = state.maybeMatch(
      rState: (data) => "FState",
      r3State: (R3State data) {},
      r4State: (R4State data) {},
    );
    print(maybeMatch);
  });
}
