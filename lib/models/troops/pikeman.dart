import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';

class Pikeman extends Troop {
  @override
  int troopNumber = 4;

  @override
  Color get color => Colors.yellow;

  @override
  Pikeman copy() {
    return Pikeman();
  }
}
