import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButtom {
  SignInButton(
      {Key key,
      @required String text,
      Color color,
      Color textColor,
      VoidCallback onPressed})
      : assert(text != null),
        super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: 16.0,
          height: 40.0,
        );
}
