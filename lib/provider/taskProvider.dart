import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasksmanager/databaseHelper.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  final List<String> _relationshipLabels = [
    'is subtask of',
    'is blocked by',
    'is alternative to',
    'depends on',
    'is related to'
  ];

  List<TaskModel> get tasks => _tasks;
  List<String> get relationshipLabels => _relationshipLabels;

  // Define a method to add the TaskModel to the database
  Future<void> addTaskToDB(TaskModel task) async {
    // create a reference to the singleton instance of DatabaseHelper
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // call a method on the instance to get the database object
    Database db = await dbHelper.database;
    print("tasks ${task.toMap()}");
    // final db = await DatabaseHelper().database;
    await db.insert('tasks', task.toMap());
  }

  // Define a method to update the TaskModel in the database
  Future<void> updateTaskInDB(TaskModel task) async {
    // create a reference to the singleton instance of DatabaseHelper
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // call a method on the instance to get the database object
    Database db = await dbHelper.database;
    // final db = await DatabaseHelper().database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Define a method to delete the TaskModel from the database
  Future<void> deleteTaskFromDB(TaskModel task) async {
    // create a reference to the singleton instance of DatabaseHelper
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // call a method on the instance to get the database object
    Database db = await dbHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Define a method to load the TaskModel data from the database
  Future<void> loadTasksFromDB() async {
    // create a reference to the singleton instance of DatabaseHelper
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // call a method on the instance to get the database object
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    _tasks = List.generate(
      maps.length,
      (i) => TaskModel.fromMap(maps[i]),
    );
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.getTasks();
    notifyListeners();
  }

  // Define a method to add a TaskModel to the provider and database
  Future<void> addTask(TaskModel task) async {
    _tasks.insert(0, task);
    await addTaskToDB(task);
    notifyListeners();
  }

  // Define a method to edit a TaskModel in the provider and database
  Future<void> editTask(TaskModel task, int index) async {
    _tasks.removeAt(index);
    _tasks.insert(0, task);
    await updateTaskInDB(task);
    notifyListeners();
  }

  // Define a method to add a relationship to a TaskModel in the provider
  void addRelationship(TaskModel task, List<TaskRelationship> relatedTask) {
    task.relatedTasks = relatedTask;
    notifyListeners();
  }

  // Define a method to edit a relationship for a TaskModel in the provider
  void editRelationship(TaskModel task, List<TaskRelationship> relatedTask) {
    task.relatedTasks = relatedTask;
    notifyListeners();
  }

  // Define a method to remove a relationship from a TaskModel in the provider
  void removeRelationship(TaskModel task, TaskRelationship relationship) {
    task.relatedTasks!.remove(relationship);
    notifyListeners();
  }
}
