import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("YOU ARE LOGGED IN"),
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/auth");
                },
                child: Text("logout"))
          ],
        ),
      ),
    );
  }
}
