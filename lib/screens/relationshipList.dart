import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';
import 'package:tasksmanager/provider/taskProvider.dart';
import 'package:tasksmanager/screens/add_relationship.dart';

class RelationshipList extends StatefulWidget {
  final List<TaskRelationship> relations;
  final Future<void> Function(BuildContext, int) editTasks;
  final Future<void> Function(BuildContext, int, String, TaskModel)
      editRelation;
  final void Function(int) removeTask;

  const RelationshipList(
      {super.key,
      required this.relations,
      required this.editTasks,
      required this.editRelation,
      required this.removeTask});

  @override
  State<RelationshipList> createState() => _RelationshipListState();
}

class _RelationshipListState extends State<RelationshipList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.relations.length,
        itemBuilder: (context, index) {
          final task = widget.relations[index];
          return InkWell(
            onTap: (() {
              widget.editTasks(context, task.relatedTask.id!);
            }),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                child: ListTile(
                    title: Text(
                      task.relatedTask.title!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(task.relation),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            widget.editRelation(context, index, task.relation,
                                task.relatedTask);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            widget.removeTask(index);
                          },
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
