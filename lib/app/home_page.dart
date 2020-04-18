import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSignOut;
  HomePage({@required this.onSignOut});

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      this.onSignOut();
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
