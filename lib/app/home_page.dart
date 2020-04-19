import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;

  HomePage({@required this.auth});

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
