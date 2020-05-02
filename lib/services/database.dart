import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';

abstract class Database {
  Future<void> createJob(Task task);
  Stream<List<Task>> taskStreams();
  Future<void> deleteJob(Task task);
}

String documnetIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid});
  final String uid;

  Future<void> createJob(Task task) async {
    print(task.id);
    final path = '/users/$uid/tasks/task_${task.id}';
    final reference = Firestore.instance.document(path);
    await reference.setData(task.toMap());
  }

  Future<void> deleteJob(Task task) async {
    // print(task.id);
    final path = 'users/$uid/tasks/task_${task.id}';
    // print(path);
    final reference =
        Firestore.instance.document('/users/$uid/tasks/${task.id}');
    await reference.delete();
    // print('deleted');
  }

  Stream<List<Task>> taskStreams() {
    final path = '/users/$uid/tasks';
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => Task(
            id: snapshot.documentID,
            name: snapshot.data['name'],
            content: snapshot.data['content'],
          ),
        )
        .toList());
  }
}
