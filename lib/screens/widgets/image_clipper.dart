import 'package:flutter/cupertino.dart';
import 'dart:math';

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.80);

    double xCenter = size.width * 0.5 + (size.width * 0.6 + 1) * sin(0 * pi);
    double yCenter = size.height * 0.8 + 69 * cos(0 * pi);

    // draw curved line
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
