import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/create_task.dart';
import 'package:tasksmanager/home.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/routes.dart';
import 'package:tasksmanager/provider/taskProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        // We can add more providers as we move forward with the app.
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Prakhar's Task Manager",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Prakhar's Task Manager"),
      routes: Routes.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  List<TaskModel> tasks = [];

  Future<void> _createNavigate(BuildContext context) async {
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);

    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTask()),
    );
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result != null) {
      tasksProvider.addTask(result);
    }
  }

  Future<void> _editNavigate(BuildContext context, task, int index) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateTask(
                isFirst: false,
                title: task.title!,
                description: task.description!,
                status: task.status!,
                time: task.time!,
              )),
    );
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result != null) {
      tasksProvider.editTask(result, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            tasksProvider.tasks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'There are no tasks currently. Please add a task.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Home(
                    tasks: tasksProvider.tasks,
                    update: _editNavigate,
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNavigate(context);
        },
        // tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
