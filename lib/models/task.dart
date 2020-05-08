import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final String content;
  final Timestamp datetime;
  Task({this.id, this.name, this.content, this.datetime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
      'datetime': datetime,
    };
  }
}
