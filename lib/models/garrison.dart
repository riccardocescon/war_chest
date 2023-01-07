import 'dart:developer';

import 'package:war_chest/models/troops/troop.dart';

class Garrison<T extends Troop> {
  final List<T> _troops = [];

  int get remainingsTroops => _troops.length;

  Map<Troop, int> get remainingsTroopsByType {
    final res = <T, int>{};
    for (T troop in _troops) {
      final containsTroop =
          res.keys.map((e) => e.runtimeType).contains(troop.runtimeType);
      if (containsTroop) {
        int value = res.entries
            .firstWhere(
                (element) => element.key.runtimeType == troop.runtimeType)
            .value;
        res.removeWhere((key, value) => key.runtimeType == troop.runtimeType);
        res.addAll({troop: value + 1});
      } else {
        res[troop] = 1;
      }
    }
    return res;
  }

  void add(T troop) {
    _troops.add(troop);
  }

  List<T> recallTroops() {
    List<T> recalledTroops = _troops.toList();
    _troops.clear();
    return recalledTroops;
  }

  void logGarrison() {
    log('Garrison:');
    for (T troop in _troops) {
      log('$troop', name: 'Garrison');
    }
  }
}
