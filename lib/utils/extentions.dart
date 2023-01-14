import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/widgets/cell.dart';

extension ListHelper<T> on List<T> {
  T? firstWhereNullable(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

extension TroopMap<T extends Troop> on Map<T, List<T>> {
  bool containsTroopType(T troop) {
    for (T troopType in keys) {
      if (troopType.runtimeType == troop.runtimeType) {
        return true;
      }
    }
    return false;
  }

  List<T> getTroopType(T troop) {
    for (T troopType in keys) {
      if (troopType.runtimeType == troop.runtimeType) {
        return this[troopType]!;
      }
    }
    throw Exception('Map does not contain this troop type');
  }
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

extension CellListHelper on List<Cell> {
  List<Cell> removeDuplicates() {
    final cells = <Cell>[];
    for (Cell cell in this) {
      if (!cells.any((element) => element.mapCoords == cell.mapCoords)) {
        cells.add(cell);
      }
    }
    return cells;
  }
}
