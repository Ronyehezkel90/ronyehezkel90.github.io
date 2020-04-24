import 'package:Nirushka/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Record.dart';

class FirestoreHandler {
  var firestoreInstance = Firestore.instance;

  Future<DocumentReference> addProject(Project project) async {
    return firestoreInstance
        .collection('projects')
        .add(project.toMap());
  }

  Future<DocumentReference> addRecord(Record record) async {
    return firestoreInstance
        .collection('records')
        .add(record.toMap());
  }

  Future<List<Record>> getAllRecords() async {
    List<Record> recordsResult = List<Record>();
    QuerySnapshot querySnapshot =
    await firestoreInstance.collection('records').getDocuments();
    for (var document in querySnapshot.documents) {
      if (document.data != null) {
        Record record = Record.fromJson(document.data);
        recordsResult.add(record);
      }
    }
    return recordsResult;
  }
  Future<List<Project>> getAllProjects() async {
    print("get projects");
    List<Project> projectsResult = List<Project>();
    QuerySnapshot querySnapshot =
    await firestoreInstance.collection('projects').getDocuments();
    for (var document in querySnapshot.documents) {
      if (document.data != null) {
        Project project = Project.fromJson(document.data);
        print("Project:" + project.title);
        projectsResult.add(project);
      }
    }
    return projectsResult;
  }
}
