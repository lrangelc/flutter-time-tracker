import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/app/sign_in/sign_in_manager.dart';
import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:flutter_time_tracker/app/sign_in/sign_in_buttom.dart';
import 'package:flutter_time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (BuildContext context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (err) {
      print(err.toString());
      _showSignInError(context, err);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (err) {
      print(err.toString());
      if (err.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, err);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (err) {
      print(err.toString());
      if (err.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, err);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      // color: Colors.yellow,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Google',
            assetName: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            key: emailPasswordKey,
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }
}
