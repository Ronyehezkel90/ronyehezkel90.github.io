import 'package:Nirushka/project.dart';
import 'package:Nirushka/user.dart';
import 'package:Nirushka/widgets.dart';
import 'package:flutter/material.dart';

import 'conts.dart';
import 'firestoreHandler.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirestoreHandler firestoreHandler = FirestoreHandler();
  TextEditingController _nameCtrl;
  TextEditingController _passCtrl;

  void initState() {
    super.initState();
    initAll();
  }

  void dispose() {
    _nameCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  initAll() {
    _nameCtrl = TextEditingController();
    _passCtrl = TextEditingController();
  }

  displayAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: new Text(loginFailureMessage),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  handleLogin(bool value) {
    if (value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      displayAlert();
    }
  }

  onLoginClick() async {
    User user = User(
        name: _nameCtrl.text.toString(), password: _passCtrl.text.toString());
    firestoreHandler.login(user).then((value) => {handleLogin(value)});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(children: <Widget>[Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1000,
          width: 800,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              getTitle(loginTitleString),
              Container(
                  width: 300,
                  height: 60,
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: userNameString,
                    ),
                  )),
              Container(
                  width: 300,
                  height: 60,
                  child: TextFormField(
                    obscureText: true,
                    controller: _passCtrl,
                    decoration: InputDecoration(
                      labelText: userPasswordString,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              getButton(loginString, onLoginClick),
            ],
          ),
        ),
      ],
    )])
        ));
  }
}
