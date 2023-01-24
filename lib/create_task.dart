import 'package:flutter/material.dart';
import 'package:tasksmanager/models/TaskModel.dart';

const List<String> statusList = <String>[
  'Status',
  'Open',
  'In Progress',
  'Completed'
];

class CreateTask extends StatefulWidget {
  final bool isFirst;
  final String title;
  final String description;
  final String status;
  final DateTime time;

  CreateTask(
      {Key? key,
      this.isFirst = true,
      this.title = '',
      this.description = '',
      DateTime? time,
      this.status = 'Status'})
      : time = time ?? DateTime.now(),
        super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> with InputValidationMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    status = widget.status;
    setState(() {
      title = widget.title;
      description = widget.description;
    });
  }

  String title = "";
  String description = "";
  String status = statusList.first;
  DateTime time = DateTime.now();

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
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Navigator.pop(
          context,
          TaskModel(
              title: title,
              description: description,
              status: status,
              time: time));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  initialValue: widget.title,
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
                  initialValue: widget.description,
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
                        "Last Updated on: ${widget.time}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              Center(
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
  bool isTitleValid(String title) => title.length >= 6;
  bool isDescriptionValid(String description) =>
      description.length > 6 && description.length <= 250;
  bool isStatusValid(String sta) => sta != statusList.first;
}
