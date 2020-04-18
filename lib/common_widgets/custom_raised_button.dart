import 'package:flutter/material.dart';

class CustomRaisedButtom extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  CustomRaisedButtom(
      {this.child,
      this.color,
      this.borderRadius,
      this.onPressed,
      this.height: 50.0});

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
