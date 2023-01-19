import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';

class Infantry extends Troop<Infantry> {
  @override
  Color get color => Colors.teal.shade400;

  @override
  int tacticRange = 1;

  @override
  Infantry copy() {
    return Infantry();
  }

  @override
  int get troopNumber => 5;
}
