import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';

class Berserker extends Troop<Berserker> {
  @override
  int troopNumber = 5;

  @override
  Color get color => Colors.green;

  @override
  Berserker copy() {
    return Berserker();
  }
}
