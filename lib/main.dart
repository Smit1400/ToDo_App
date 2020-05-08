import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/landing_page.dart';
import 'package:todo_app/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (context) => Auth(),
      child: MaterialApp(
        home: LandingPage(),
      ),
    );
  }
}
