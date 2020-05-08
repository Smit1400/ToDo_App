import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Database database;

  const TaskListTile({Key key, this.task, this.database}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final DateTime date = task.datetime.toDate();
    return Dismissible(
      key: Key('task-${task.id}'),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _delete(),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${task.name}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                  color: Colors.grey[200]),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'Content: ${task.content}',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Colors.grey[200]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Day: ${weekdays[date.weekday - 1]}, Date: ${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Time: ${date.hour}:${date.minute} hour',
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Swipe to delete',
                    style: TextStyle(color: Colors.red, fontSize: 10)),
              ],
            ),
          ],
        ),

        // subtitle: Text(task.name),
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
