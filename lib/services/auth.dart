import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((firebaseUser) => _userFromFirebase(firebaseUser));
    // return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

// Future<FacebookLoginResult> facebookLogin() async {
//     final facebookLogin = FacebookLogin();
//     bool isLoggedIn = await facebookLogin.isLoggedIn;
//     if (isLoggedIn) {
//       facebookLogin.logOut();
//     }

//     return facebookLogin.logIn(['email']);
//   }

// /// This mehtod makes the real auth
// Future<FirebaseUser> firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {

//     AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
//     final autResult = await _firebaseAuth.signInWithCredential(credential);
//     FirebaseUser firebaseUser = autResult.user;
//     return firebaseUser;
// }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();

    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    String code = '';
    String message = '';

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);

        final authResult = await _firebaseAuth.signInWithCredential(credential);

        return _userFromFirebase(authResult.user);
      // return firebaseUser;

      //     var firebaseUser = await firebaseAuthWithFacebook(
      //         token: accessToken);

      //     _showMessage('''
      //      Logged in!

      //      Token: ${accessToken.token}
      //      User id: ${accessToken.userId}
      //      Expires: ${accessToken.expires}
      //      Permissions: ${accessToken.permissions}
      //      Declined permissions: ${accessToken.declinedPermissions}
      //      ''');

      //     break;

      case FacebookLoginStatus.cancelledByUser:
        code = 'ERROR_ABORTED_BY_USER';
        message = 'Sign in aborted by user';
        break;

      case FacebookLoginStatus.error:
        code = 'ERROR_FACEBOOK_LOGIN';
        message = 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}';
        break;
    }

    throw PlatformException(code: code, message: message);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final FacebookLogin facebookSignIn = new FacebookLogin();

    await googleSignIn.signOut();
    await facebookSignIn.logOut();
    await _firebaseAuth.signOut();
  }

}
