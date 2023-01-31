import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';
import 'package:tasksmanager/screens/add_relationship.dart';
import 'package:tasksmanager/screens/relationshipList.dart';

import '../provider/taskProvider.dart';

const List<String> statusList = <String>[
  'Status',
  'Open',
  'In Progress',
  'Completed'
];

class CreateTask extends StatefulWidget {
  final bool isFirst;
  final int id;

  const CreateTask({super.key, this.isFirst = true, this.id = 0});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> with InputValidationMixin {
  final formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  late int id;
  String status = statusList.first;
  DateTime time = DateTime.now();
  List<TaskRelationship> relatedTasks = [];

  @override
  void initState() {
    super.initState();
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);
    if (!widget.isFirst) {
      TaskModel task =
          tasksProvider.tasks.firstWhere((element) => element.id == widget.id);
      setState(() {
        title = task.title!;
        description = task.description!;
        id = task.id!;
        status = task.status!;
        relatedTasks = task.relatedTasks!;
      });
    } else {
      setState(() {
        id = tasksProvider.tasks.length;
      });
    }
  }

  void onChangedTitle(String newText) {
    if (newText.isNotEmpty) {
      setState(() {
        title = newText;
      });
    }
  }

  void onChangedDescription(String newText) {
    if (newText.isNotEmpty) {
      setState(() {
        description = newText;
      });
    }
  }

  void onUpdate() {
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var result = TaskModel(
          id: id,
          title: title,
          description: description,
          status: status,
          relatedTasks: relatedTasks,
          time: time);
      if (!widget.isFirst) {
        int index =
            tasksProvider.tasks.indexWhere((element) => element.id == id);
        tasksProvider.editTask(result, index);
        tasksProvider.editRelationship(result, relatedTasks);
      } else {
        tasksProvider.addTask(result);
        tasksProvider.addRelationship(result, relatedTasks);
      }
      Navigator.pop(context);
    }
  }

  Future<void> _addRelation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRelationship()),
    );
    if (result != null) {
      setState(() {
        relatedTasks.add(result);
      });
    }
  }

  Future<void> _editRelation(
      BuildContext context, int index, String relation, TaskModel task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddRelationship(
                relation: relation,
                task: task,
              )),
    );
    if (result != null) {
      setState(() {
        relatedTasks.removeAt(index);
        relatedTasks.insert(0, result);
      });
    }
  }

  Future<void> _editTask(BuildContext context, int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateTask(
                isFirst: false,
                id: id,
              )),
    );
  }

  void _removeRelation(int index) {
    setState(() {
      relatedTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirst ? "Create Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  initialValue: title,
                  onChanged: onChangedTitle,
                  maxLines: 2,
                  minLines: 1,
                  validator: (val) {
                    if (isTitleValid(val!)) {
                      return null;
                    }
                    return "Please enter title at least more than 6 letters";
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: description,
                  onChanged: onChangedDescription,
                  maxLines: 2,
                  validator: (val) {
                    if (isDescriptionValid(val!)) {
                      return null;
                    }
                    return "Please enter description in not more than 250 letters";
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter description',
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: status,
                    // Down Arrow Icon
                    validator: (val) {
                      if (isStatusValid(val!)) {
                        return null;
                      } else {
                        return "Please select the status of the task";
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: statusList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                    isExpanded: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select Status"),
                  )),
              !widget.isFirst
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Last Updated on: ${time}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              relatedTasks.isNotEmpty
                  ? RelationshipList(
                      relations: relatedTasks,
                      editTasks: _editTask,
                      editRelation: _editRelation,
                      removeTask: _removeRelation)
                  : Container(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: onUpdate,
                    child: Text(
                      widget.isFirst ? "Submit" : "Update",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    // style: ElevatedButton.,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: tasksProvider.tasks.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                _addRelation(context);
                // Add your onPressed code here!
              },
              label: const Text('Add Relationship'),
              icon: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}

// #For Validation
mixin InputValidationMixin {
  bool isTitleValid(String title) => title.length >= 3;
  bool isDescriptionValid(String description) =>
      description.length > 2 && description.length <= 250;
  bool isStatusValid(String sta) => sta != statusList.first;
}
