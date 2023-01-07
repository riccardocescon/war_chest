import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/models/bag.dart';
import 'package:war_chest/models/troops/berserker.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/models/troops/warden.dart';

void main() {
  test(
    "Success Draw Troop",
    () => _drawTroopTest(
      expectRes: true,
      troopsToAdd: [Warden(), Berserker()],
    ),
  );

  test(
    "Failure Draw Troop: Bag Empty",
    () => _drawTroopTest(
      expectRes: false,
      troopsToAdd: [],
    ),
  );
}

void _drawTroopTest({
  required bool expectRes,
  required List<Troop> troopsToAdd,
}) {
  final bag = Bag();
  for (final current in troopsToAdd) {
    bag.add(current);
  }
  try {
    bag.drawTroop();
    expect(true, expectRes);
  } catch (e) {
    expect(false, expectRes);
  }
}
