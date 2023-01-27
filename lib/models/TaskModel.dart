import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  String? status;
  DateTime? time;
  List<TaskRelationship>? relatedTasks;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      this.time,
      this.relatedTasks});
}
