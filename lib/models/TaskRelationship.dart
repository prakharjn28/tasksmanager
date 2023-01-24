import 'TaskModel.dart';

class TaskRelationship {
  final TaskModel relatedTask;
  String label;

  TaskRelationship({
    required this.relatedTask,
    this.label = "",
  });
}
