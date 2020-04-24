import 'package:Nirushka/project.dart';
import 'package:Nirushka/widgets.dart';
import 'package:flutter/material.dart';

import 'conts.dart';
import 'firestoreHandler.dart';
import 'main.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  FirestoreHandler firestoreHandler = FirestoreHandler();
  TextEditingController _nameCtrl;
  bool isLoading;

  void initState() {
    super.initState();
    initAll();
  }

  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  initAll() {
    _nameCtrl = TextEditingController();
    isLoading = false;
  }

  displayAlert(bool success) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: new Text(success ? successMessage : failureMessage),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (success) {
                    setState(() {
                      initAll();
                    });
                  }
                },
              )
            ],
          );
        });
  }

  bool successValidation() {
    return _nameCtrl.text.toString() != "";
  }

  onAddProjectClick() async {
    if (successValidation()) {
      CircularProgressIndicator();
      setState(() {
        isLoading = true;
      });
      Project project = createProject();
      await firestoreHandler
          .addProject(project)
          .then((value) => {displayAlert(true)});
    }
    else {
      displayAlert(false);
    }
  }

  onAddDealClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  Project createProject() {
    return Project(
      title: _nameCtrl.text.toString(),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isLoading
                    ? CircularProgressIndicator()
                    : Container(
                  height: 1000,
                  width: 800,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      getTitle(projectTitleString),
                      getTextField(_nameCtrl, projectName),
                      SizedBox(height: 10,),
                      getButton(addProjectString, onAddProjectClick),
                      getButton(goToDealsPageString, onAddDealClick),
                    ],
                  ),
                ),
              ],
            )));
  }
}
