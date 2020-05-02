import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database.dart';

class RegisterTodoTask extends StatefulWidget {
  final Database database;

  const RegisterTodoTask({Key key, this.database}) : super(key: key);

  @override
  _RegisterTodoTaskState createState() => _RegisterTodoTaskState();
}

class _RegisterTodoTaskState extends State<RegisterTodoTask> {
  String _name;
  String _content;
  final _formKey = GlobalKey<FormState>();

  bool _onRegister() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _createJob(BuildContext context) async {
    if (_onRegister()) {
      try {
        final id = documnetIdFromCurrentDate();
        print(id);
        final Task task = Task(id: id, name: _name, content: _content);
        await widget.database.createJob(task);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New task'),
        centerTitle: true,
        titleSpacing: 1.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Name Can\'t be empty' : null,
                  onSaved: (name) => _name = name,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Content',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Content cannot be empty' : null,
                  onSaved: (content) => _content = content,
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      'Register Task',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _createJob(context),
                    color: Colors.indigo[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
