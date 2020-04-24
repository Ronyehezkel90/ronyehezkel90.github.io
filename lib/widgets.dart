import 'package:Nirushka/conts.dart';
import 'package:Nirushka/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget getTitle(String text) {
  return Container(
      width: 800,
      height: 100,
      child: Text(text,
          style: TextStyle(fontSize: 50, color: Colors.white54),
          textAlign: TextAlign.center));
}

Widget getTextField(
    TextEditingController textEditingController, String labelName) {
  return Container(
      width: 300,
      height: 60,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: labelName,
            ),
          )));
}

Widget getNumbersField(
    TextEditingController textEditingController, String labelName) {
  return new Container(
      width: 300,
      height: 60,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            decoration: new InputDecoration(labelText: labelName),
            controller: textEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          )));
}

Widget getProjectDropDown(
    String projectName, String projectValue, List<Project> projects, onChanged) {
  return DropdownButton<String>(
    value: projectValue,
    elevation: 16,
    hint: Text(projectName),
    onChanged: (String newValue) {
      onChanged(newValue);
    },
    items: projects.map((project) => project.title)
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Widget getDealDatePicker(onClick, dealDate) {
  return Material(
    borderRadius: BorderRadius.circular(5.0),
    color: Colors.grey,
    child: MaterialButton(
      onPressed: () {
        onClick();
      },
//      minWidth: MediaQuery.of(context).size.width,
      child: Text(
        dealDate,
      ),
    ),
  );
}

Widget getMishtakenPriceSwitcher(bool isMishtakenPriceSwitched, onSwitch) {
  return Container(
      child: Column(
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Text(mishtakenString,
          style: TextStyle(fontSize: 15, color: Colors.black54),
          textAlign: TextAlign.center),
      Switch(
          value: isMishtakenPriceSwitched,
          onChanged: (value) {
            onSwitch(value);
          },
          activeTrackColor: Color.fromRGBO(47, 56, 70, 1),
          activeColor: Color.fromRGBO(129, 203, 236, 1)),
    ],
  ));
}

Widget getButton(buttonTxt, onClick) {
  return OutlineButton(
      child: Text(
        buttonTxt,
        style: TextStyle(fontSize: 20),
      ),
      borderSide: BorderSide(color: Colors.white, width: 3),
      onPressed: () => onClick(),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)));
}
