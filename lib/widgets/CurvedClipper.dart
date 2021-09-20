import 'package:flutter/material.dart';

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.8);

    Offset curvedPoint1 = Offset(size.width / 4, size.height);
    Offset centerPoint = Offset(size.width / 2, size.height * 0.8);

    path.quadraticBezierTo(
      curvedPoint1.dx,
      curvedPoint1.dy,
      centerPoint.dx,
      centerPoint.dy,
    );

    Offset curvedPoint2 = Offset(size.width * 3 / 4, size.height * 0.6);
    Offset endPoint = Offset(size.width, size.height * 0.8);

    path.quadraticBezierTo(
      curvedPoint2.dx,
      curvedPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
