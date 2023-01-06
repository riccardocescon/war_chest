import 'dart:math';

import 'package:flutter/cupertino.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Draw a square hexagon
    final hOffset = size.height * 0.05;
    final path = Path();
    path.lineTo(size.width * 0.25, hOffset);
    path.lineTo(size.width * 0.75, hOffset);
    path.lineTo(size.width, size.height * sqrt(3) / 4 + hOffset);
    path.lineTo(size.width * 0.75, size.height * sqrt(3) / 2 + hOffset);
    path.lineTo(size.width * 0.25, size.height * sqrt(3) / 2 + hOffset);
    path.lineTo(0, size.height * sqrt(3) / 4 + hOffset);
    path.lineTo(size.width * 0.25, hOffset);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
