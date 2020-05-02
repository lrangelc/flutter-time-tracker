import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/app/sign_in/validators.dart';
import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => this._emailController.text;
  String get _password => this._passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    print('dispose called');
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submint() async {
    setState(() {
      this._submitted = true;
      this._isLoading = true;
    });

    if (_email.isNotEmpty && _password.isNotEmpty) {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);

        if (_formType == EmailSignInFormType.signIn) {
          await auth.signInWithEmailAndPassword(this._email, this._password);
        } else {
          await auth.createUserWithEmailAndPassword(
              this._email, this._password);
        }
        Navigator.of(context).pop();
      } on PlatformException catch (err) {
        PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: err,
        ).show(context);
      } finally {
        this._isLoading = false;
        setState(() {});
      }
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    this._submitted = false;
    _formType = _formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    _emailController.clear();
    _passwordController.clear();

    setState(() {});
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
    final secondText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        _email.isNotEmpty &&
        _password.isNotEmpty &&
        !this._isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submint : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondText),
        onPressed: this._isLoading ? null : _toggleFormType,
      ),
    ];
  }

  _updateState() {
    setState(() {});
  }

  TextField _buildEmailTextField() {
    bool showErrorText =
        this._submitted && !widget.emailValidator.isValid(this._email);

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'text@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: !this._isLoading,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        this._submitted && !widget.emailValidator.isValid(this._password);

    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: !this._isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submint,
      onChanged: (password) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
