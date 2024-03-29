# @FpState

The `@FpState` annotation is used in dependency with the `fp_state_generator` package to generate template code for managing state 

## Installation

To use the `@FpState` annotation, you need to add the `fp_state_generator` package as a dependency in your `pubspec.yaml` file:


* [example](./example/test/data_test.dart) 



```dart
import 'package:fp_state_annotation/fp_state_annotation.dart';
part 'my_file.fpState.dart';
/// Make sure state implement in same file
/// run `flutter pub run build_runner build` to generate the file
//  @fpState
@FpState()
class UiState {}

class LState extends UiState {}

class RState extends UiState {}

class R3State extends UiState {}

class R4State extends UiState {}


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
    orElse: (data) => "OrElse result",
  );
  //  matchOrElse => "OrElse result"

  final maybeMatch = state.maybeMatch(
    rState: (data) => "FState",
    r3State: (R3State data) {},
    r4State: (R4State data) {},
  );
  // maybeMatch = null


```

* support freezed package

```dart
import 'package:fp_state_annotation/fp_state_annotation.dart';
part 'my_file.fp_state.dart';
/// Make sure state implement in same file
/// run `flutter pub run build_runner build` to generate the file

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


```