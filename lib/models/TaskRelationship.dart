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
    return TaskRelationship(
      relatedTask: TaskModel(
        id: map['related_task_id'],
        title: '',
        description: '',
        status: '',
        time: null,
      ),
      relation: map['relation'],
    );
  }
}
