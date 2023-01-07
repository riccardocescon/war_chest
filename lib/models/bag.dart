import 'dart:developer';

import 'package:war_chest/models/troops/troop.dart';

class Bag<T extends Troop> {
  final List<T> _troops = [];

  int get remainingsTroops => _troops.length;

  void add(T troop) {
    _troops.add(troop);
  }

  void shuffle() {
    _troops.shuffle();
  }

  T drawTroop({T Function()? onException}) {
    if (_troops.isEmpty) {
      if (onException != null) {
        return onException();
      }
      throw Exception(
        'Bag is empty, no onException() provided',
      );
    }
    return _troops.removeAt(0);
  }

  void logBag() {
    log('Bag:', name: 'Bag');
    for (T troop in _troops) {
      log('$troop', name: 'Bag');
    }
  }
}
