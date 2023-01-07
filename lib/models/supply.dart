import 'dart:developer';

import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/extentions.dart';

class Supply<T extends Troop> {
  final Map<T, List<T>> _troops = {};

  int get remainingsTroops {
    int res = 0;
    for (T troopType in _troops.keys) {
      res += _troops[troopType]!.length;
    }
    return res;
  }

  Map<Troop, int> get remainingsTroopsByType {
    final res = <T, int>{};
    for (T troopType in _troops.keys) {
      res[troopType] = _troops[troopType]!.length;
    }
    return res;
  }

  void addTroopSet(T troop, {void Function()? onException}) {
    int troopNumber = troop.troopNumber;
    if (_troops.containsTroopType(troop)) {
      if (onException != null) {
        onException();
        return;
      }
      throw Exception(
        'Supply already contains this troop type, no onException() provided',
      );
    }
    _troops.addAll({troop: []});
    for (int i = 0; i < troopNumber; i++) {
      _troops[troop]!.add(troop.copy());
    }
  }

  T recruit(T troopType, {T Function()? onException}) {
    if (!_troops.containsTroopType(troopType)) {
      if (onException != null) {
        return onException();
      }
      throw Exception(
        'Supply does not contain this troop type, no onException() provided',
      );
    }
    final troops = _troops.getTroopType(troopType);
    if (troops.isEmpty) {
      if (onException != null) {
        return onException();
      }
      throw Exception(
        'Supply is empty, no onException() provided',
      );
    }
    return troops.removeAt(0);
  }

  void logSupply() {
    log('Supply:', name: 'Supply');
    for (T troopType in _troops.keys) {
      log('$troopType: ${_troops[troopType]!.length}', name: 'Supply');
    }
  }
}
