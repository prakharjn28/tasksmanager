import 'package:flutter/material.dart';
import 'package:tasksmanager/screens/add_relationship.dart';
import 'package:tasksmanager/screens/create_task.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String createTask = '/createTask';
  static const String addRelation = '/addRelation';

  static final routes = <String, WidgetBuilder>{
    createTask: (BuildContext context) => CreateTask(),
    addRelation: (context) => AddRelationship(),
  };
}
