import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksmanager/provider/loginProvider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void loginAnonymously() async {
    var loginProvider = Provider.of<LoginProvider>(context, listen: false);

    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      loginProvider.setPrefItems(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return Dialog(
                    child: Text(
                        "Anonymous auth hasn't been enabled for this project."));
              });
          break;
        default:
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return Dialog(child: Text("Unknown Error."));
              });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
            child: ElevatedButton(
          onPressed: loginAnonymously,
          child: Text('Login Anonymously'),
        )),
      ),
    );
  }
}
