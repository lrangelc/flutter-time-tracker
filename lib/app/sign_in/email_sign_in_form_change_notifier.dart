import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';

import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  EmailSignInFormChangeNotifier({@required this.model});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    print('dispose called');
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submint() async {
    try {
      await model.submint();

      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: err,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
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
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submint : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: model.isLoading ? null : _toggleFormType,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'text@test.com',
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submint,
      // onChanged: (password) => widget.bloc.updatePassword(password),
      onChanged: model.updatePassword,
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
