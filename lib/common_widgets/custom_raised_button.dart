import 'package:flutter/material.dart';

class CustomRaisedButtom extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  CustomRaisedButtom(
      {Key key,
      this.child,
      this.color,
      this.borderRadius: 2.0,
      this.onPressed,
      this.height: 50.0})
      : assert(borderRadius != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      child: RaisedButton(
        child: this.child,
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(this.borderRadius),
          ),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
