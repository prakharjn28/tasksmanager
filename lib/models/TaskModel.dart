import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  String? status;
  DateTime? time;
  List<TaskRelationship>? relatedTasks;
  String? imageAddress;
  int public;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      this.time,
      this.relatedTasks,
      this.imageAddress,
      this.public = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'time': time?.millisecondsSinceEpoch,
      'relatedTasks': relatedTasks
          ?.whereType<TaskModel>()
          .map((relatedTask) => relatedTask.toMap())
          .toList(),
      'imageAddress': imageAddress,
      'public': public
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
        imageAddress: map['imageAddress'],
        public: map['public']);
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        time: json['time'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['time'])
            : null,
        relatedTasks: (json['relatedTasks'] as List<dynamic>?)
            ?.map((item) => TaskRelationship.fromMap(item))
            .toList(),
        imageAddress: json['imageAddress'],
        public: json['public']);
  }
}
