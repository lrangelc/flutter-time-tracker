import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  EmailSignInBloc({@required this.auth});

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submint() async {
    updateWith(submitted: true, isLoading: true);

    if (_model.email.isNotEmpty && _model.password.isNotEmpty) {
      try {
        if (_model.formType == EmailSignInFormType.signIn) {
          await auth.signInWithEmailAndPassword(_model.email, _model.password);
        } else {
          await auth.createUserWithEmailAndPassword(
              _model.email, _model.password);
        }
      } catch (err) {
        rethrow;
      } finally {
        updateWith(isLoading: false);
      }
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool submitted}) {
    // update model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);

    // add updated model to _modelController
    _modelController.add(_model);
  }
}
