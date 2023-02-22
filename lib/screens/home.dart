import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/provider/taskProvider.dart';
import 'package:tasksmanager/screens/create_task.dart';

import '../models/TaskModel.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _editTask(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateTask(
                isFirst: false,
                id: id,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TaskProvider>(
        builder: (context, taskList, _) => ListView.builder(
          itemCount: taskList.tasks.length,
          itemBuilder: (context, index) {
            final task = taskList.tasks[index];
            return InkWell(
              onTap: () {
                _editTask(context, task.id!);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                child: Card(
                  child: ListTile(
                    title: Text(
                      task.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    trailing: const Icon(Icons.edit),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
