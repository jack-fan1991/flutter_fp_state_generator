import 'package:fp_state_generator/fp_state_annotation.dart';

part 'test_data.fp_state.dart';

@FpState()
class UiState {}

class LState extends UiState {}

class RState extends UiState {}

class R3State extends UiState {}

class R4State extends UiState {}

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
}
