import 'package:flutter/material.dart';

abstract class Troop<T> {
  int get troopNumber;
  Color get color;
  int get tacticRange;
  int reiforceLevel = 0;
  Widget draw(double size, {Widget? child}) {
    return Container(
      width: size * 0.75,
      height: size * 0.75,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }

  T copy();
}
