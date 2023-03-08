import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  String _uid = "";
  void setPrefItems(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    _uid = uid;
    notifyListeners();
  }

  String get uid => _uid;

  getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('uid') ?? "";
    notifyListeners();
  }

  removePrefItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    _uid = "";
    notifyListeners();
  }
}
