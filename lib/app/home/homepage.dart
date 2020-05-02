import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/register_todo_task.dart';
import 'package:todo_app/app/home/task_list_tile.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/database.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onButtonPressed(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterTodoTask(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        titleSpacing: 1.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              auth.signOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _onButtonPressed(context),
      ),
    );
  }

  Widget _buildContents() {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Task>>(
      stream: database.taskStreams(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data;
          final children = tasks
              .map((task) => TaskListTile(task: task, database: database))
              .toList();
          return ListView(
            children: children,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Some Error Occurred'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
