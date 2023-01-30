import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double iconSize;

  const ProfileImage({
    required this.imageUrl,
    this.height = 50,
    this.width = 50,
    this.iconSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    return
      ClipOval(
      child:
        imageUrl != '' ?
          Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ) : Container(
              width: width,
              height: height,
              color: Color(0xFF9bbbd4),
              child: Icon(
                Icons.person,
                size: iconSize,
                color: Colors.white70,
              ),
          ),
      );
  }
}
