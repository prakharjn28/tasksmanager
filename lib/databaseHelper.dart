import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasksmanager/models/TaskModel.dart';

import 'models/TaskRelationship.dart';

class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _databaseVersion = 1;

  static const tableTasks = 'tasks';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnStatus = 'status';
  static const columnTime = 'time';
  static const columnRelatedTasks = 'relatedTasks';
  static const columnImageAddress = 'imageAddress';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE $tableTasks (
  $columnId INTEGER PRIMARY KEY,
  $columnTitle TEXT NOT NULL,
  $columnDescription TEXT NOT NULL,
  $columnStatus TEXT NOT NULL,
  $columnTime INTEGER,
  $columnRelatedTasks TEXT,
  $columnImageAddress TEXT
  )
''');
  }

// Helper methods

// Convert a TaskModel object into a Map object
  Map<String, dynamic> _taskToMap(TaskModel task) {
    Map<String, dynamic> map = {
      columnTitle: task.title,
      columnDescription: task.description,
      columnStatus: task.status,
      columnTime: task.time?.millisecondsSinceEpoch,
      columnRelatedTasks:
          jsonEncode(task.relatedTasks?.map((rel) => rel.toMap()).toList()),
      columnImageAddress: task.imageAddress
    };
    if (task.id != null) {
      map[columnId] = task.id;
    } else {
      // generate a new id value
      map[columnId] = DateTime.now().microsecondsSinceEpoch;
    }
    return map;
  }

// Convert a Map object into a TaskModel object
  TaskModel _mapToTask(Map<String, dynamic> map) {
    return TaskModel(
        id: map[columnId],
        title: map[columnTitle],
        description: map[columnDescription],
        status: map[columnStatus],
        time: map[columnTime] != null
            ? DateTime.fromMillisecondsSinceEpoch(map[columnTime])
            : null,
        relatedTasks: map[columnRelatedTasks]?.isNotEmpty == true
            ? (jsonDecode(map[columnRelatedTasks]) as List<dynamic>)
                .map((rel) => TaskRelationship.fromMap(rel))
                .toList()
            : null,
        imageAddress: map[columnImageAddress]);
  }

// Insert a new task into the database
  Future<void> insertTask(TaskModel task) async {
    Database db = await instance.database;
    await db.insert(tableTasks, _taskToMap(task));
  }

// Update a task in the database
  Future<void> updateTask(TaskModel task) async {
    Database db = await instance.database;
    await db.update(tableTasks, _taskToMap(task),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

// Delete a task from the database
  Future<void> deleteTask(TaskModel task) async {
    Database db = await instance.database;
    await db.delete(tableTasks, where: '$columnId = ?', whereArgs: [task.id]);
  }

// Get a list of all tasks from the database
  Future<List<TaskModel>> getTasks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableTasks);
    return List.generate(maps.length, (i) => _mapToTask(maps[i]));
  }
}
