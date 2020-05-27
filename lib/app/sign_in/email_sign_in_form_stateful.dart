import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';

import 'package:flutter_time_tracker/app/sign_in/validators.dart';
import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  final VoidCallback onSignedIn;

  EmailSignInFormStateful({this.onSignedIn});

  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String get _email => this._emailController.text;
  String get _password => this._passwordController.text;
  String get _confirmPassword => this._confirmPasswordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    print('dispose called');
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      this._submitted = true;
      this._isLoading = true;
    });

    if (_email.isNotEmpty &&
        _password.isNotEmpty &&
        (_formType == EmailSignInFormType.register
            ? _confirmPassword.isNotEmpty
            : true) &&
        (_formType == EmailSignInFormType.register
            ? _password == _confirmPassword
            : true)) {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);

        if (_formType == EmailSignInFormType.signIn) {
          await auth.signInWithEmailAndPassword(this._email, this._password);
        } else {
          await auth.createUserWithEmailAndPassword(
              this._email, this._password);
        }
        if (widget.onSignedIn != null) {
          widget.onSignedIn();
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
    } else {
      setState(() {
        this._submitted = false;
        this._isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    if (_formType == EmailSignInFormType.register) {
      final newFocus = widget.passwordValidator.isValid(_password)
          ? _confirmPasswordFocusNode
          : _passwordFocusNode;
      FocusScope.of(context).requestFocus(newFocus);
    } else {
      _submit();
    }
  }

  void _toggleFormType() {
    this._submitted = false;
    _formType = _formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

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
        (_formType == EmailSignInFormType.register
            ? widget.passwordValidator.isValid(_confirmPassword)
            : true) &&
        (_formType == EmailSignInFormType.register
            ? _password == _confirmPassword
            : true) &&
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
      if (_formType == EmailSignInFormType.register)
        _buildConfirmPasswordTextField(),
      if (_formType == EmailSignInFormType.register)
        SizedBox(
          height: 16.0,
        ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
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
      key: Key('email'),
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
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
        this._submitted && !widget.passwordValidator.isValid(this._password);

    return TextField(
      key: Key('password'),
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: !this._isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _passwordEditingComplete,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildConfirmPasswordTextField() {
    bool showErrorText = this._submitted &&
        (!widget.passwordValidator.isValid(this._confirmPassword) ||
            !(this._password == this._confirmPassword));
    print(!widget.passwordValidator.isValid(this._confirmPassword));
    String errorText;
    if (showErrorText) {
      if (!widget.passwordValidator.isValid(this._confirmPassword)) {
        errorText = widget.invalidPasswordErrorText;
      } else {
        errorText = widget.invalidConfirmPasswordErrorText;
      }
    }
    return TextField(
      key: Key('confirmPassword'),
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: showErrorText ? errorText : null,
        enabled: !this._isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (confirmPassword) => _updateState(),
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
