import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskModel {
  String? title;
  String? description;
  String? status;
  DateTime? time;

  TaskModel({
    required this.title,
    required this.description,
    required this.status,
    this.time,
  });
}
