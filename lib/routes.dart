import 'package:flutter/material.dart';
import 'package:tasksmanager/create_task.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String createTask = '/createTask';

  static final routes = <String, WidgetBuilder>{

    createTask: (BuildContext context) => CreateTask(),
  };
}
