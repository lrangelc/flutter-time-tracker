import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final double radius;

  const Avatar({Key key, this.photoUrl, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black12,
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
      child: photoUrl == null
          ? Icon(
              Icons.camera_alt,
              size: radius,
            )
          : null,
    );
  }
}
