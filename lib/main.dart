import 'dart:ffi';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksmanager/provider/loginProvider.dart';
import 'package:tasksmanager/screens/login.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tasksmanager/screens/create_task.dart';
import 'package:tasksmanager/screens/home.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/routes.dart';
import 'package:tasksmanager/provider/taskProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: ((context) => LoginProvider()))
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
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await context.read<LoginProvider>().getPrefItems();
    await context.read<TaskProvider>().mergeTasks();
    context.read<TaskProvider>().loadTasks();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void logout() async {
    var loginPro = Provider.of<LoginProvider>(context, listen: false);
    await FirebaseAuth.instance.signOut();
    loginPro.removePrefItem();
  }

  void scanQrCode() async {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: (result != null)
                        ? Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                        : Text('Scan a code'),
                  ),
                )
              ],
            ),
          );
        });
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  List<TaskModel> tasks = [];

  Future<void> _createNavigate(BuildContext context) async {
    var tasksProvider = Provider.of<TaskProvider>(context, listen: false);

    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateTask(
                id: tasksProvider.tasks.length,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        if (loginProvider.uid.isEmpty) {
          return Login();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Scan qr code',
                  onPressed: () {
                    scanQrCode();
                    // handle the press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    logout();
                    // handle the press
                  },
                ),
              ],
            ),
            body: Center(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    Duration(seconds: 1),
                    () {
                      context.read<TaskProvider>().mergeTasks();
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    tasksProvider.tasks.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'There are no tasks currently. Please add a task.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Home()
                  ],
                ),
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
      },
    );
  }
}
