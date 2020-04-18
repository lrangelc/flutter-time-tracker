import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButtom {
  SocialSignInButton(
      {String text,
      Color color,
      Color textColor,
      VoidCallback onPressed,
      String assetName})
      : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: 16.0,
          height: 40.0,
        );
}
