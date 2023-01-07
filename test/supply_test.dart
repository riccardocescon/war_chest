import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/models/supply.dart';
import 'package:war_chest/models/troops/berserker.dart';
import 'package:war_chest/models/troops/marshal.dart';
import 'package:war_chest/models/troops/pikeman.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/models/troops/warden.dart';

void main() {
  group("Add Troop Set", () {
    test(
      'Success Supply Setup',
      () => _addTroopSet(
        expectRes: true,
        troopsToAdd: [Warden(), Berserker(), Pikeman(), Marshal()],
      ),
    );
    test(
      'Failure Supply Setup: Same Troop Type',
      () => _addTroopSet(
        expectRes: false,
        troopsToAdd: [Warden(), Berserker(), Berserker(), Marshal()],
      ),
    );
  });

  group("Recruit From Supply", () {
    test(
      "Success Recruitment",
      () => _recruit(expectRes: true, troop: Warden(), remainingTroops: true),
    );

    test(
      "Failure Recruitment: Supply Empty",
      () => _recruit(expectRes: false, troop: Warden(), remainingTroops: false),
    );

    test(
      "Failure Recruitment: Troop Not In Supply",
      () => _recruit(expectRes: false, troop: Marshal(), remainingTroops: true),
    );
  });
}

void _addTroopSet({
  required bool expectRes,
  required List<Troop> troopsToAdd,
}) {
  final supply = Supply();
  try {
    for (Troop troop in troopsToAdd) {
      supply.addTroopSet(troop);
    }
    expect(true, expectRes);
  } catch (e) {
    expect(false, expectRes);
  }
}

void _recruit({
  required bool expectRes,
  required Troop troop,
  required bool remainingTroops,
}) {
  final supply = Supply();
  List<Troop> troopsToAdd = [Warden(), Berserker(), Pikeman()];
  for (Troop troop in troopsToAdd) {
    supply.addTroopSet(troop);
  }

  try {
    if (!remainingTroops) {
      for (int i = 0; i < Warden().troopNumber; i++) {
        supply.recruit(troop);
      }
    }
    supply.recruit(troop);
    expect(true, expectRes);
  } catch (e) {
    expect(false, expectRes);
  }
}
