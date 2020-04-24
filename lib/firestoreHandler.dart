import 'package:Nirushka/project.dart';
import 'package:Nirushka/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Record.dart';

class FirestoreHandler {
  var firestoreInstance = Firestore.instance;

  Future<DocumentReference> addProject(Project project) async {
    return firestoreInstance.collection('projects').add(project.toMap());
  }

  Future<DocumentReference> addRecord(Record record) async {
    return firestoreInstance.collection('records').add(record.toMap());
  }

  Future<bool> login(User user) async {
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('users')
        .where("name", isEqualTo: user.name)
        .where("password", isEqualTo: user.password)
        .getDocuments();
    return querySnapshot.documents.length > 0;
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
