import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  SignInBloc({@required this.auth});

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (err) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
