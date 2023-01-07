import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/models/commander.dart';
import 'package:war_chest/models/troops/berserker.dart';
import 'package:war_chest/models/troops/marshal.dart';
import 'package:war_chest/models/troops/warden.dart';

void main() {
  test('Draw all bag', () {
    _drawAllTroops();
  });
  test('Refill and draw', () {
    _refillAndDrawTroops();
  });
  test('Draw max 2 Troops', () {
    _refillAndDraw2MaxTroops();
  });
}

void _drawAllTroops() {
  final Commander commander = Commander([Warden(), Berserker(), Marshal()]);
  commander.clearHand();
  commander.drawTroops();

  expect(commander.handSize, 3);
  expect(commander.bagSize, 0);
  expect(commander.supplySize, 8);
  expect(commander.garrisonSize, 3);
}

void _refillAndDrawTroops() {
  final Commander commander = Commander([Warden(), Berserker(), Marshal()]);
  commander.switchTroop();
  commander.clearHand();
  commander.drawTroops();

  expect(commander.handSize, 3);
  expect(commander.bagSize, 3);
  expect(commander.supplySize, 8);
  expect(commander.garrisonSize, 0);
}

void _refillAndDraw2MaxTroops() {
  final Commander commander = Commander([Warden(), Berserker(), Marshal()]);
  commander.destroyBagTroop();
  commander.destroyBagTroop();
  commander.destroyBagTroop();
  commander.destroyHandTroop();
  commander.clearHand();
  commander.drawTroops();

  expect(commander.handSize, 2);
  expect(commander.bagSize, 0);
  expect(commander.supplySize, 8);
  expect(commander.garrisonSize, 0);
}
