import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/sign_in/email_sign_in_form.dart';
import 'package:flutter_time_tracker/services/auth_provider.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(
              auth: auth,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
