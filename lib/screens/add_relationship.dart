import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/models/TaskRelationship.dart';

import '../provider/taskProvider.dart';

const List<String> relations = [
  'is subtask of',
  'is blocked by',
  'is alternative to',
  'depends on',
  'is related to'
];

class AddRelationship extends StatefulWidget {
  final String? relation;
  final TaskModel? task;
  const AddRelationship({super.key, this.relation, this.task});

  @override
  State<AddRelationship> createState() => _AddRelationship();
}

class _AddRelationship extends State<AddRelationship>
    with InputValidationMixin {
  final formKey = GlobalKey<FormState>();
  String? relation;
  TaskModel? task;

  @override
  void initState() {
    super.initState();
    setState(() {
      relation = widget.relation;
      task = widget.task;
    });
  }

  void onChange(value) {
    setState(() {
      task = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);
    var taskList = tasksProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Relation"),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: task,
                    hint: const Text('Select Task'),
                    validator: (val) {
                      // if (isStatusValid(val!)) {
                      //   return null;
                      // } else {
                      //   return "Please select the status of the task";
                      // }
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: taskList.map((TaskModel items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.title!),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: onChange,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: relation,
                    hint: Text('Add new relation'),
                    // Down Arrow Icon
                    validator: (val) {
                      if (isRelationValid(val!)) {
                        return null;
                      } else {
                        return "Please select the relation with the task";
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: relations.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        relation = newValue!;
                      });
                    },
                    isExpanded: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select Relation"),
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: (() {
                      Navigator.pop(
                          context,
                          TaskRelationship(
                              relatedTask: task!, relation: relation!));
                    }),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    // style: ElevatedButton.,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// #For Validation
mixin InputValidationMixin {
  bool isRelationValid(String sta) => sta != relations.first;
}
