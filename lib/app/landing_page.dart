import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/homepage.dart';
import 'package:todo_app/app/signin/email_sign_in_page.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/database.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return EmailSignInPage();
            } else {
              return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
