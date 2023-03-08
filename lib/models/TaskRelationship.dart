import 'TaskModel.dart';

class TaskRelationship {
  final TaskModel relatedTask;
  String relation;

  TaskRelationship({
    required this.relatedTask,
    this.relation = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'related_task_id': relatedTask.id,
      'relation': relation,
    };
  }

  factory TaskRelationship.fromMap(Map<String, dynamic> map) {
    final relatedTaskId = map['related_task_id'];
    final relatedTasks = TaskModel.fromMap(map).relatedTasks;
    final relatedTask = relatedTasks
        ?.firstWhere((task) => task.relatedTask.id == relatedTaskId)
        .relatedTask;

    return TaskRelationship(
      relatedTask: relatedTask ??
          TaskModel(
            id: relatedTaskId,
            title: '',
            description: '',
            status: '',
            time: null,
          ),
      relation: map['relation'],
    );
  }
}
