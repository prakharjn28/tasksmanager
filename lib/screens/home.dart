import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/provider/taskProvider.dart';
import 'package:tasksmanager/screens/create_task.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

import '../models/TaskModel.dart';

class Home extends StatefulWidget {
  Home({Key? key, QrDataObject? dataObject}) : super(key: key);

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

  void generateQr(int id) {
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);
    TaskModel task =
        tasksProvider.tasks.firstWhere((element) => element.id == id);
    QrDataObject dataObject = QrDataObject(
        title: task.title!,
        description: task.description!,
        status: task.status!);

    final jsonString = jsonEncode(dataObject);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  QrImage(
                    data: jsonString,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 16.0),
                  Text('Scan this QR code to add the data into your list'),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TaskProvider>(
        builder: (context, taskList, _) => ListView.builder(
          itemCount: taskList.tasks.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final task = taskList.tasks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Card(
                child: ListTile(
                  title: Text(
                    task.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () => generateQr(task.id!),
                        icon: Icon(
                          Icons.share,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _editTask(context, task.id!),
                        icon: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
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

class QrDataObject {
  final String title;
  final String description;
  final String status;

  QrDataObject({this.title = '', this.description = '', this.status = ''});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'status': status};
  }
}
