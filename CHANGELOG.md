# 0.0.17
- update ResultFailed({this.error}); =>  ResultFailed([this.error]);

# 0.0.16
- update ResultFailed(this.error); =>  ResultFailed({this.error});

# 0.0.15
- Feature AsyncLoading class to include a cache property as nullable

# 0.0.14
- Feature AsyncLoading class to include a cache property in async_state.dart

# 0.0.13
- fix bug generic type missing, 

# 0.0.12
- When the class does not have member variables, use void callback.
- Export AsyncState,Result  for easy to use
- sdk version sdk: '>=3.0.0 <4.0.0'

# 0.0.11
- fix bug freezed not support generic type

# 0.0.10
- fix bug when class has generic type

# 0.0.9
- remove unused code

# 0.0.8
# 0.0.7
- support generics class

# 0.0.6
- Breaking change: rename '*.fp_State.dart' to '*.fpState.dart'

- Feature: auto generated part '*.fpState.dart' when run flutter pub run build_runner build 

- Fix when sealed class has no subclasses extensions are  generated failed 

# 0.0.5

- Support freezed package

# 0.0.4

- Update package info for scores

# 0.0.3

- Update package info

# 0.0.2

- Update package yaml

# 0.0.1

- Initial release!