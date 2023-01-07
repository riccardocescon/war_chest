import 'package:flutter/cupertino.dart';

class BagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width * 0.4, 0);
    path.lineTo(size.width * 0.45, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.2,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 1.1,
      size.width * 0.5,
      size.height,
    );
    path.lineTo(size.width * 0.5, size.height);

    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 1.1,
      size.width * 0.8,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.3,
      size.width * 0.55,
      size.height * 0.2,
    );
    path.lineTo(size.width * 0.6, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
