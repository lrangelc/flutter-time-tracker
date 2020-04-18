import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButtom {
  SignInButton(
      {String text, Color color, Color textColor, VoidCallback onPressed})
      : super(
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
