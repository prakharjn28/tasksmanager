import 'package:flutter/material.dart';

import 'models/TaskModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.tasks, required this.update})
      : super(key: key);
  final List<TaskModel> tasks;
  final Future<void> Function(BuildContext, dynamic, int) update;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return InkWell(
            onTap: () {
              widget.update(context, task, index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
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
    );
  }
}
