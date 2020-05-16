import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/avatar.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _builUserInfo(user),
        ),
      ),
    );
  }

  Widget _builUserInfo(User user) {
    return Avatar(
      photoUrl: user.photoUrl,
      radius: 50.0,
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signOut();
    } catch (err) {
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: err.toString(),
        defaultActionText: 'OK',
      ).show(context);
    }
  }
}
