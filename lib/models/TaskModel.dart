import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  String? status;
  DateTime? time;
  List<TaskRelationship>? relatedTasks;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.time,
    this.relatedTasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'time': time?.millisecondsSinceEpoch,
      'relatedTasks':
          relatedTasks?.map((relationship) => relationship.toMap()).toList(),
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'])
          : null,
      relatedTasks: (map['relatedTasks'] as List<dynamic>?)
          ?.map((item) => TaskRelationship.fromMap(item))
          .toList(),
    );
  }
}
