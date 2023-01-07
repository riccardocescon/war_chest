import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';

class Warden extends Troop {
  @override
  int troopNumber = 4;

  @override
  Color get color => Colors.blue;

  @override
  Warden copy() {
    return Warden();
  }
}
