import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker/app/home_page.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;

  LandingPage({@required this.auth});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  void _updateUser(User user) {
    if (user != null) {
      print('User id: ${user.uid}');
    }
    _user = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    } else {
      return HomePage(
        auth: widget.auth,
        onSignOut: () => _updateUser(null),
      );
    }
  }
}
