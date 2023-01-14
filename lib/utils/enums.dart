import 'package:flutter/material.dart';

enum Team {
  white,
  black,
}

enum GameAction {
  deploy,
  reinforce,
  move,
  attack,
  tattic,
  claim,
  recruit,
  initiative,
  pass,
}

enum MapCellType {
  empty,
  normal,
  zone,
  team,
  teamZone,
  whiteZone,
  blackZone,
}
