import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/services/auth.dart';

class AuthProvider extends InheritedWidget {
  final AuthBase auth;
  final Widget child;

  AuthProvider({@required this.auth, @required this.child});

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  //final auth = AuthProvider.of(context);
  static AuthBase of(BuildContext context) {
    AuthProvider provider =
        context.dependOnInheritedWidgetOfExactType(aspect: AuthProvider);
    return provider.auth;
  }
}
