import 'package:flutter/cupertino.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<String> _relationshipLabels = [
    'is subtask of',
    'is blocked by',
    'is alternative to',
    'depends on',
    'is related to'
  ];
  List<TaskModel> get tasks => _tasks;

  List<String> get relationshipLabels => _relationshipLabels;

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void editTask(TaskModel task, int index) {
    _tasks.removeAt(index);
    _tasks.insert(0, task);
    notifyListeners();
  }

  // void addRelationship(TaskModel task, TaskRelationship relationship) {
  //   task.relationships.add(relationship);
  //   notifyListeners();
  // }

  // void removeRelationship(TaskModel task, TaskRelationship relationship) {
  //   task.relationships.remove(relationship);
  //   notifyListeners();
  // }
}
