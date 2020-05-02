import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Database database;

  const TaskListTile({Key key, this.task, this.database}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('task-${task.id}'),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _delete(),
      child: ListTile(
        title: Text(task.content),
        subtitle: Text(task.name),
      ),
    );
  }

//if request.auth.uid == uid
  Future<void> _delete() async {
    try {
      // print(task.content);
      await database.deleteJob(task);
      // print(task.id);
    } catch (e) {
      print(e.toString());
    }
  }
}
