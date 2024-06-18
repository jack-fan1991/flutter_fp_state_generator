import 'package:fp_state_generator/fp_state_annotation.dart';
part 'test.fpState.dart';

@fpState
class TaskListCacheModel<T> {
  final T? taskListModel;
  TaskListCacheModel(this.taskListModel);
}

class TaskListCacheAddListButton extends TaskListCacheModel {
  TaskListCacheAddListButton() : super(null);
}
