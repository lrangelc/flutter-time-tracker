import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButtom {
  FormSubmitButton({@required String text, VoidCallback onPressed})
      : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          color: Colors.indigo,
          onPressed: onPressed,
          borderRadius: 16.0,
          height: 40.0,
        );
}
