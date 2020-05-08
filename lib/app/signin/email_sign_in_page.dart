import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/homepage.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/services/auth.dart';

enum EmailFormType { signIn, register }

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool submitted = false;
  EmailFormType _formType = EmailFormType.signIn;

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailFormType.signIn
          ? EmailFormType.register
          : EmailFormType.signIn;
      submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  void _submit() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      if (_formType == EmailFormType.register) {
        User user =
            await auth.createUserWithEmailAndPassword(_email, _password);
        if (user != null) {
          print('user: ${user.uid}');
        } else {
          print("Error occured");
        }
      } else {
        User user = await auth.signInWithEmailAndPassword(_email, _password);
        if (user != null) {
          print('user: ${user.uid}');
        } else {
          print("Error occured");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildContent() {
    String emailErrorText = _email.isEmpty ? 'Email Cannot be empty' : null;
    String passwordErrorText =
        _password.isEmpty ? 'Password cannot be empty' : null;

    String mainText = _formType == EmailFormType.signIn ? 'Sign In' : 'Sign up';
    String primaryText =
        _formType == EmailFormType.signIn ? 'Log in' : 'Create an account';
    String secondaryText = _formType == EmailFormType.signIn
        ? 'Don\'t have an account? Sign up'
        : 'Already have an account? Log in';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Welcome to ToDo App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  mainText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'test@test.com',
                    labelText: 'Email',
                    errorText: submitted ? emailErrorText : null,
                  ),
                  onChanged: (email) => setState(() {}),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: submitted ? passwordErrorText : null,
                  ),
                  obscureText: true,
                  onChanged: (password) => setState(() {}),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 48,
                  child: RaisedButton(
                    child: Text(
                      primaryText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    color: Colors.grey[200],
                    disabledColor: Colors.grey[200],
                    onPressed: () {
                      print('Email: $_email and Password: $_password');
                      _submit();
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    secondaryText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[500],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  disabledColor: Colors.indigo,
                  onPressed: _toggleFormType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
