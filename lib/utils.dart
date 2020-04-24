import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:html' as html;

import 'Record.dart';

class Utils{

  /// Convert a map list to csv
  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List(keyIndexMap.length);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[]
      ..add(keys)
      ..addAll(data));
  }

  sendMail(firestoreHandler) async {
    String csvString = await getCsv(firestoreHandler);
    final bytes = utf8.encode(csvString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final Email email = Email(
      body: url.toString(),
      subject: 'Nirushka',
      recipients: ['ronyehezkel90@gmail.com'],
      cc: ['ronyehezkel90@gmail.com'],
//      bcc: ['bcc@example.com'],
//      attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    print(platformResponse);
  }

  downloadFile(firestoreHandler) async {
    String csvString = await getCsv(firestoreHandler);
    final bytes = utf8.encode(csvString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'some_name.csv';
    html.document.body.children.add(anchor);
// download
    anchor.click();
// cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    print("download");
  }

  Future<String> getCsv(firestoreHandler) async {
    List<Record> allRecords = await firestoreHandler.getAllRecords();
    List<Map<String, dynamic>> mapList = List();
    for (Record record in allRecords) {
      mapList.add(record.toMap());
    }
    String csv = mapListToCsv(mapList);
    return csv;
  }

}