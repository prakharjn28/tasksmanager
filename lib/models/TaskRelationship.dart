import 'TaskModel.dart';

class TaskRelationship {
  final TaskModel relatedTask;
  String relation;

  TaskRelationship({
    required this.relatedTask,
    this.relation = "",
  });
}
