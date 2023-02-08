import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/provider/taskProvider.dart';
import 'package:tasksmanager/screens/create_task.dart';
import 'package:tasksmanager/widgets/TaskTile.dart';

import '../models/TaskModel.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
  void editTask(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateTask(
                isFirst: false,
                id: id,
              )),
    );
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: tasksProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = tasksProvider.tasks[index];
          return InkWell(
              onTap: () {
                widget.editTask(context, task.id!);
              },
              child: TaskTile(title: task.title!));
        },
      ),
    );
  }
}
