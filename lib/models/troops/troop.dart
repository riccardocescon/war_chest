import 'package:flutter/material.dart';

abstract class Troop {
  Color get color;
  Widget draw(double size) {
    return Container(
      width: size * 0.75,
      height: size * 0.75,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
