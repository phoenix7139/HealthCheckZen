import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_check_zen/utilities/constants.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './verify.dart';

enum AuthMode { register, login }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Map<String, dynamic> user = {
    "name": "",
    "token": "",
    "isAuthenticated": false,
    "email": "",
    "password": ""
  };

  void autoAuthenticate() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear(); //remove this to save user data
    var _token = prefs.getString("token");
    print(_token);
    if (_token != null) {
      setState(() {
        user["isAuthenticated"] = true;
        user["token"] = prefs.getString("token");
        user["email"] = prefs.getString("email");
        user["password"] = prefs.getString("password");
        user["name"] = prefs.getString("name");
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  final Map<String, dynamic> _loginFormData = {
    "email_id": null,
    "password": null,
  };

  final Map<String, dynamic> _registerFormData = {
    "name": "",
    "email_id": "",
    "password": null,
  };

  bool _isLoading = false;
  bool _obscurePassword = true;
  String api_url = "http://34.93.21.176";
  AuthMode _authmode = AuthMode.login;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _passwordTextController = TextEditingController();

  Future userLogin(final Map<String, dynamic> user) async {
    setState(() {
      _isLoading = true;
    });
    print(_loginFormData);
    http.Response response = await http.post(Uri.encodeFull("$api_url/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_loginFormData));
    var data = json.decode(response.body);
    print(response.body);
    print(data);
    if (data["success"] == false) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("unable to log in with provided credentials"),
          duration: Duration(seconds: 1),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    } else {
      Navigator.pushReplacementNamed(context, "/home");
      // user["token"] = data["token"];
      // user["isAuthenticated"] = true;
      // user["password"] = _loginFormData["password"];
      // print(user["token"]);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("token", user["token"]);
      // prefs.setString("password", user["password"]);
      // prefs.setString("email", user["email"]);

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Logged in"),
          duration: Duration(seconds: 1),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future userRegister(final Map<String, dynamic> user) async {
    setState(() {
      _isLoading = true;
    });
    print(_registerFormData);
    http.Response response = await http.post(Uri.encodeFull("$api_url/signup"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_registerFormData));
    var data = json.decode(response.body);
    print(data);
    if (data["error"] == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("succesful"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Verify(_registerFormData),
        ),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("a user with that email already exists"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
    }
    // if (data.length == 1) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text("a user with that username already exists"),
    //     duration: Duration(seconds: 1),
    //   ));
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } else {
    //   user["username"] = data["user"]["username"];
    //   user["token"] = data["token"];
    //   user["isAuthenticated"] = true;

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("username", user["username"]);
    //   prefs.setString("token", user["token"]);
    //   prefs.setString("password", _registerFormData["password"]);

    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Logged in"),
    //     duration: Duration(seconds: 1),
    //   ));
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.pushReplacementNamed(context, '/home');
    // }
  }

  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _passwordTextController,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon:
                    Icon(_obscurePassword ? Icons.remove_red_eye : Icons.lock),
                color: Colors.white.withOpacity(0.7),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              // filled: true,
              // fillColor: Colors.white.withOpacity(0.7),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "password",
              labelStyle: kHintTextStyle

              // TextStyle(
              //   color: Colors.white.withOpacity(0.7),
              // )
              ,
            ),
            obscureText: _obscurePassword ? true : false,
            validator: (String value) {
              if (value.isEmpty) {
                return "Password too short";
              }
            },
            onSaved: (String value) {
              _authmode == AuthMode.login
                  ? _loginFormData["password"] = value
                  : _registerFormData["password"] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.person_outline,
                color: Colors.white.withOpacity(0.7),
              ),
              // filled: true,
              // fillColor: Colors.white.withOpacity(0.7),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "name",
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Please enter a valid name";
              }
            },
            onSaved: (String value) {
              _registerFormData["name"] = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.email,
                color: Colors.white.withOpacity(0.7),
              ),
              // filled: true,
              // fillColor: Colors.white.withOpacity(0.7),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "email",
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (String value) {
              if (value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)) {
                return 'Please enter a valid email';
              }
            },
            onSaved: (String value) {
              _authmode == AuthMode.login
                  ? _loginFormData["email_id"] = value
                  : _registerFormData["email_id"] = value;
            },
          ),
        ),
      ],
    );
  }

  void _submitForm(final Map<String, dynamic> user) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _authmode == AuthMode.login ? userLogin(user) : userRegister(user);
  }

  @override
  Widget build(BuildContext context) {
    final double _targetWidth = MediaQuery.of(context).size.width > 550.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.95;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        // decoration: BoxDecoration(
        //   // color: Colors.grey,//TODO:Need to change here
        //   // image: _buildBackgroundImage(),
        // ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF398AE5),
              Color(0xFF478DE0),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: _targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: _authmode == AuthMode.login
                            ? MediaQuery.of(context).size.height / 6
                            : 0),
                    _authmode == AuthMode.login
                        ? Container()
                        : _nameTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _emailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _passwordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'switch to ${_authmode == AuthMode.login ? 'register' : 'login'}',
                              // style: TextStyle(color: Colors.white),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _authmode = _authmode == AuthMode.login
                                    ? AuthMode.register
                                    : AuthMode.login;
                              });
                            },
                          ),
                          _isLoading
                              ? Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                  ))
                              : FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // color: Colors.white.withOpacity(0.3),
                                  color: Color(0xFF527DAA),
                                  splashColor: Theme.of(context).accentColor,
                                  child: Text(
                                    '${_authmode == AuthMode.login ? 'LOGIN' : 'REGISTER'}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () => _submitForm(user),
                                ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
