import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future loginWithEmail(
      {@required String email, @required String password}) async {
    bool check;
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
//      print(user != null);
      check = user != null;
    } catch (e) {
//      print(e.message);
//      return e.message;   
    }
    return check;
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
  }) async {
    bool check;
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
//      print(authResult.user != null);
      check = authResult.user != null;
    } catch (e) {
//      print(e.message);
//      return e.message;
    }
    return check;
  }

  Future passwordReset({@required String email}) async {
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError((err) {});
  }
}
