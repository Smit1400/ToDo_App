import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/empty_page.dart';
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
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.grey[200],
          ),
        ),
        centerTitle: true,
        titleSpacing: 1.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              auth.signOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.grey[200],
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
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
          if (tasks.isNotEmpty) {
            final children = tasks
                .map((task) => TaskListTile(task: task, database: database))
                .toList();
            return ListView(
              children: children,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nothing Here',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Add a new item to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          print("hello: ${snapshot.error}");
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
