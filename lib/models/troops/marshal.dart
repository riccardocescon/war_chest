import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';

class Marshal extends Troop {
  @override
  int troopNumber = 5;

  @override
  int tacticRange = 2;

  @override
  Color get color => Colors.red;

  @override
  Marshal copy() {
    return Marshal();
  }
}
