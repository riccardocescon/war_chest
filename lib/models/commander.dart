import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:war_chest/models/bag.dart';
import 'package:war_chest/models/garrison.dart';
import 'package:war_chest/models/supply.dart';
import 'package:war_chest/models/troops/troop.dart';

class Commander<T extends Troop<dynamic>> {
  final Supply _supply = Supply();
  final Garrison _garrison = Garrison();
  final Bag _bag = Bag();
  final List<Troop<dynamic>> _hand = [];

  int get handSize => _hand.length;
  int get supplySize => _supply.remainingsTroops;
  int get bagSize => _bag.remainingsTroops;
  int get garrisonSize => _garrison.remainingsTroops;

  List<Troop<dynamic>> get hand => _hand;
  Map<Troop, int> get supplyMap => _supply.remainingsTroopsByType;
  Map<Troop, int> get garrisonMap => _garrison.remainingsTroopsByType;

  Commander(List<T> troopSets) {
    // Add the troop sets to the supply
    for (T currentTroopSet in troopSets) {
      _supply.addTroopSet(currentTroopSet);
    }

    // Draw 2 troops from each supply and add them to the bag
    for (T currentTroopSet in troopSets) {
      _bag.add(_supply.recruit(currentTroopSet));
      _bag.add(_supply.recruit(currentTroopSet));
    }

    // Draw 3 troops from the bag and add them to the hand
    drawTroops();
  }

  void drawTroops() {
    _bag.shuffle();
    if (_bag.remainingsTroops > 2) {
      _hand.add(_bag.drawTroop());
      _hand.add(_bag.drawTroop());
      _hand.add(_bag.drawTroop());
      return;
    }

    // recruit remaining troops from the bag
    while (_bag.remainingsTroops > 0) {
      _hand.add(_bag.drawTroop());
    }

    // refill the bag
    for (Troop<dynamic> currentTroop in _garrison.recallTroops()) {
      _bag.add(currentTroop);
    }

    // if there are less than 3 troops in the bag, recruit remaining troops from the supply
    if (_hand.length + _bag.remainingsTroops < 3) {
      while (_bag.remainingsTroops > 0) {
        _hand.add(_bag.drawTroop());
      }
      return;
    }

    // draw remaining troops from the bag and add them to the hand until the hand has 3 troops
    while (_hand.length < 3) {
      _hand.add(_bag.drawTroop());
    }
  }

  @visibleForTesting
  void clearHand() {
    for (final current in _hand.toList()) {
      _garrison.add(current);
      _hand.remove(current);
    }
  }

  @visibleForTesting
  void switchTroop() {
    _garrison.add(_hand.removeAt(0));
    _hand.add(_bag.drawTroop());
  }

  @visibleForTesting
  void destroyBagTroop() {
    _bag.drawTroop();
  }

  @visibleForTesting
  void destroyHandTroop() {
    _hand.removeAt(0);
  }

  void logCommander() {
    _supply.logSupply();
    _garrison.logGarrison();
    _bag.logBag();
    log('Hand:', name: 'Hand');
    for (Troop<dynamic> currentTroop in _hand) {
      log("$currentTroop", name: 'Hand');
    }
  }
}
