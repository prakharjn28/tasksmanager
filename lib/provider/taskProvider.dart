import 'package:flutter/cupertino.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  final List<String> _relationshipLabels = [
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

  void addRelationship(TaskModel task, List<TaskRelationship> relatedTask) {
    task.relatedTasks = relatedTask;
    notifyListeners();
  }

  void editRelationship(TaskModel task, List<TaskRelationship> relatedTask) {
    task.relatedTasks = relatedTask;
    notifyListeners();
  }

  void removeRelationship(TaskModel task, TaskRelationship relationship) {
    task.relatedTasks!.remove(relationship);
    notifyListeners();
  }
}
