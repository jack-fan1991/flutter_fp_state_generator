# @FpState

The `@FpState` annotation is used in dependency with the `fp_state_generator` package to generate template code for managing state 

## Installation

To use the `@FpState` annotation, you need to add the `fp_state_generator` package as a dependency in your `pubspec.yaml` file:


* [example](./example/test/data_test.dart) 

* [More detail in test](./example/test/data_test.dart)

* If you forget to add the `@FpState` annotation, you can run the command `flutter pub run build_runner build` after first failed it will insert 'part 'my_file.fpState.dart;' then run the command again to generate the file
```dart
import 'package:fp_state_annotation/fp_state_annotation.dart';
part 'my_file.fpState.dart';
/// Make sure state implement in same file
/// run `flutter pub run build_runner build` to generate the file

@fpState
class UiState {}

class LState extends UiState {}

class RState extends UiState {}

class R3State extends UiState {}

class MemberState extends UiState {
  final String user;
  MemberState(this.user);
}


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
  const factory FreezedState.NoMember() = NoMember;
  const factory FreezedState.FreezedState(final String user) = FreezedState1;
  const factory FreezedState.FreezedState2(final String user, final String id) =
      FreezedState2;
  const factory FreezedState.FreezedState3(
      final String user, final bool activate) = FreezedState3;
}


```

## Easy to use state
* [AsyncState](./lib/open_state/async_state/async_state.dart)
* [Result](./lib/open_state/result/result.dart)
