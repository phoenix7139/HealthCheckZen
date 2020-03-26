import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Verify extends StatefulWidget {
  final Map<String, dynamic> _registerFormData;

  Verify(this._registerFormData);

  @override
  _VerifyState createState() => _VerifyState(_registerFormData);
}

class _VerifyState extends State<Verify> {
  final Map<String, dynamic> _registerFormData;
  _VerifyState(this._registerFormData);

  @override
  void initState() {
    checkVerified();
    super.initState();
  }

  bool _isVerified = false;
  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  Future checkVerified() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(
        Uri.encodeFull("http://34.93.21.176/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_registerFormData));
    var data = json.decode(response.body);
    print(data);
    _isVerified = data["success"];
    if(_isVerified == false)
    {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("not verified"),
        duration: Duration(seconds: 1),
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("verified"),
        duration: Duration(seconds: 1),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: _isVerified
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("your account has been verified"),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/home");
                        },
                        child: Text("PROCEED"))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "a link has been sent to your email id. please verify your email by clicking onthe link"),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            checkVerified();
                          });
                        },
                        child: Text("VERIFIED"))
                  ],
                ),
        ),
      ),
    );
  }
}
