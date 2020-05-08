import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  DateTime _date;
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
        Timestamp datetime_to_timestamp = Timestamp.fromDate(_date);
        final Task task = Task(
            id: id,
            name: _name,
            content: _content,
            datetime: datetime_to_timestamp);
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
        backgroundColor: Colors.black87,
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
                  child: FlatButton(
                    color: Colors.grey[200],
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
                          maxTime: DateTime(2100, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          _date = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      _date == null ? 'Select date and time' : '$_date',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      'Register Task',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => _createJob(context),
                    color: Colors.grey[200],
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
