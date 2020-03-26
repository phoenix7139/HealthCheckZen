import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './pages/authentication.dart';
import './pages/homepage.dart';
import './pages/verify.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aarohan App",
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: "/auth",
      routes: <String, WidgetBuilder>{
        "/auth": (BuildContext context) => AuthPage(),
        "/home": (BuildContext context) => HomePage(),

      },
    );
  }
}
