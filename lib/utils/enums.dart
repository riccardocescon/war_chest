import 'package:flutter/material.dart';

enum Team {
  white,
  black,
}

extension TeamHelper on Team {
  Color get color => this == Team.white
      ? const Color.fromARGB(255, 255, 200, 35)
      : Colors.grey.shade600;
  Color get insetBorderColor =>
      this == Team.white ? Colors.amber.shade600 : Colors.grey.shade700;
  Color get centerColor =>
      this == Team.white ? Colors.amberAccent.shade200 : Colors.grey.shade800;
}
