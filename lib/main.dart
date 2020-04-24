import 'package:Nirushka/conts.dart';
import 'package:Nirushka/firestoreHandler.dart';
import 'package:Nirushka/project.dart';
import 'package:Nirushka/projectPage.dart';
import 'package:Nirushka/utils.dart';
import 'package:Nirushka/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'Record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nirushka',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.indigo,
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Nirushka'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Utils utils = Utils();
  FirestoreHandler firestoreHandler = FirestoreHandler();
  bool isLoading;

  TextEditingController _projectCtrl;
  TextEditingController _entrepreneurCtrl;
  TextEditingController _dealDateCtrl;
  TextEditingController _buyersCtrl;
  TextEditingController _aptNumberCtrl;
  TextEditingController _dealPriceCtrl;
  TextEditingController _lawyersParticipatePriceCtrl;
  String projectDropdownValue;
  String dealDateValue;
  List<Project> projects;
  bool isMishtakenPrice;

  void initState() {
    super.initState();
    initAll();
  }

  void dispose() {
    _projectCtrl.dispose();
    _entrepreneurCtrl.dispose();
    _dealDateCtrl.dispose();
    _buyersCtrl.dispose();
    _aptNumberCtrl.dispose();
    _dealPriceCtrl.dispose();
    _lawyersParticipatePriceCtrl.dispose();
    super.dispose();
  }

  onProjectChange(String newValue) {
    setState(() {
      projectDropdownValue = newValue;
    });
  }

  onMishtakenPriceChange(bool newValue) {
    setState(() {
      isMishtakenPrice = newValue;
    });
  }

  onDealDateClicked() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1990, 1, 1),
        maxTime: DateTime.now(), onConfirm: (date) {
      dealDateValue =
          '${date.day.toString()}/${date.month.toString()}/${date.year.toString()}';
      setState(() {});
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  initAll() async {
    isLoading = false;
    _projectCtrl = TextEditingController();
    _entrepreneurCtrl = TextEditingController();
    _dealDateCtrl = TextEditingController();
    _buyersCtrl = TextEditingController();
    _aptNumberCtrl = TextEditingController();
    _dealPriceCtrl = TextEditingController();
    _lawyersParticipatePriceCtrl = TextEditingController();
    dealDateValue = dealDate;
    projectDropdownValue = null;
    isMishtakenPrice = false;
    projects = new List();
    getProjects();
  }

  getProjects() async {
    List<Project> loadedProjects = await firestoreHandler.getAllProjects();
    setState(() {
      projects = loadedProjects;
    });
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
                  if (success) {
                    Navigator.of(context).pop();
                    setState(() {
                      initAll();
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  bool successValidation() {
    return projectDropdownValue != null &&
        _entrepreneurCtrl.text.toString() != "" &&
        _dealDateCtrl.text.toString() != dealDate &&
        _buyersCtrl.text.toString() != "" &&
        _aptNumberCtrl.text.toString() != "" &&
        _dealPriceCtrl.text.toString() != "" &&
        _lawyersParticipatePriceCtrl.text.toString() != "";
  }

  onAddDealClick() async {
    if (successValidation()) {
      CircularProgressIndicator();
      setState(() {
        isLoading = true;
      });
      Record record = createRecord();
      await firestoreHandler
          .addRecord(record)
          .then((value) => {displayAlert(true)});
    } else {
      displayAlert(false);
    }
  }

  onAddProjectClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage()));
  }

  Record createRecord() {
    return Record(
      entrepreneur: _entrepreneurCtrl.text.toString(),
      dealDate: dealDateValue,
      apartmentNumber: int.parse(_aptNumberCtrl.text.toString()),
      project: projectDropdownValue,
      buyers: _buyersCtrl.text.toString(),
      price: int.parse(_dealPriceCtrl.text.toString()),
      isMishtakenPrice: isMishtakenPrice,
      legalPayment: int.parse(_lawyersParticipatePriceCtrl.text.toString()),
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
                    getTitle(dealTitleString),
                    getTextField(_entrepreneurCtrl, entrepreneurName),
                    getProjectDropDown(projectName, projectDropdownValue,
                        projects, onProjectChange),
                    getDealDatePicker(onDealDateClicked, dealDateValue),
                    getNumbersField(_aptNumberCtrl, aptNumberString),
                    getTextField(_buyersCtrl, buyerName),
                    getNumbersField(_dealPriceCtrl, dealPriceString),
                    getNumbersField(_lawyersParticipatePriceCtrl,
                        lawyersParticipatePriceString),
                    getMishtakenPriceSwitcher(
                        isMishtakenPrice, onMishtakenPriceChange),
                    getButton(addDealString, onAddDealClick),
                    getButton(goToProjectsPageString, onAddProjectClick),
                    FlatButton(
                      child: Text("Download excel"),
                      onPressed: () => {utils.downloadFile(firestoreHandler)},
                    ),
                    FlatButton(
                      child: Text("Send mail"),
                      onPressed: () => {utils.sendMail(firestoreHandler)},
                    )
                  ],
                ),
              ),
      ],
    )));
  }
}
