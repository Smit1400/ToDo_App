import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/user.dart';

abstract class AuthService {
  Future<FirebaseUser> signInAnonymous();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User> get user;
}

class Auth implements AuthService {
  final _auth = FirebaseAuth.instance;

  User userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebase);
  }

  Future<FirebaseUser> signInAnonymous() async {
    AuthResult result = await _auth.signInAnonymously();
    return result.user;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
