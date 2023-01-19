import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/api/map_api.dart';
import 'package:war_chest/models/troops/berserker.dart';
import 'package:war_chest/models/troops/pikeman.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/models/troops/warden.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/widgets/standard_map.dart';

void main() {
  test(
    "No troop Deployed",
    () {
      final warden = Warden();
      _getMapActions(
        troop: warden,
        expectedActions: [
          GameAction.deploy,
        ],
        onCustomizeMap: (mapApi) {},
      );
    },
  );
  test(
    "Troop on empty Map",
    () {
      final warden = Warden();
      _getMapActions(
        troop: warden,
        expectedActions: [
          GameAction.reinforce,
          GameAction.move,
        ],
        onCustomizeMap: (mapApi) {
          final cell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 38,
          );
          mapApi.deploy(warden, cell);
        },
      );
    },
  );

  test(
    "Troop with near enemies",
    () {
      final warden = Warden();
      _getMapActions(
        troop: warden,
        expectedActions: [
          GameAction.reinforce,
          GameAction.move,
          GameAction.attack,
        ],
        onCustomizeMap: (mapApi) {
          final wardenCell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 38,
          );
          mapApi.deploy(warden, wardenCell);
          final enemyCell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 45,
          );
          mapApi.deploy(Berserker(), enemyCell);
        },
      );
    },
  );

  test(
    "Troop empty on Zone",
    () {
      final warden = Warden();
      _getMapActions(
        troop: warden,
        expectedActions: [
          GameAction.reinforce,
          GameAction.move,
          GameAction.claim,
        ],
        onCustomizeMap: (mapApi) {
          final wardenCell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 17,
          );
          mapApi.deploy(warden, wardenCell);
        },
      );
    },
  );

  test(
    "Troop on Zone with near enemies",
    () {
      final warden = Warden();
      _getMapActions(
        troop: warden,
        expectedActions: [
          GameAction.reinforce,
          GameAction.move,
          GameAction.claim,
          GameAction.attack,
        ],
        onCustomizeMap: (mapApi) {
          final wardenCell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 17,
          );
          mapApi.deploy(warden, wardenCell);
          final enemyCell = mapApi.cells.firstWhere(
            (element) => element.mapCoords == 10,
          );
          mapApi.deploy(Pikeman(), enemyCell);
        },
      );
    },
  );
}

/*
  Standard Map:
     ┌----┐    ┌----┐    ┌++++┐    ┌----┐    ┌----┐
┌----| __ |----| __ |++++| 35 |++++| __ |----| __ |----┐
| __ |----| __ |++++| 28 |----| 42 |++++| __ |----| __ |
|----| __ |++++| 22 |----| 36 |----| 50 |++++| __ |----|
| __ |++++| 15 |----| 29 |----| 43 |----| 57 |++++| __ |
|++++| 09 |----| 23 |----| 37 |----| 51 |----| 65 |++++|
| 02 |----| 16 |----| 30 |----| 44 |----| 58 |----| 72 |
|----| 10 |----| 24 |----| 38 |----| 52 |----| 66 |----|
| 03 |----| 17 |----| 31 |----| 45 |----| 59 |----| 73 |
|++++| 11 |----| 25 |----| 39 |----| 53 |----| 67 |++++|
| __ |++++| 18 |----| 32 |----| 46 |----| 60 |++++| __ |
|----| __ |++++| 26 |----| 40 |----| 54 |++++| __ |----|
| __ |----| __ |++++| 33 |----| 47 |++++| __ |----| __ |
|----| __ |----| __ |++++| 41 |++++| __ |----| __ |----|
| __ |----| __ |----| __ |++++| __ |----| __ |----| __ |
└----┘    └----┘    └----┘    └----┘    └----┘    └----┘

*/

void _getMapActions({
  required Troop troop,
  required Iterable<GameAction> expectedActions,
  required void Function(MapApi mapApi) onCustomizeMap,
}) {
  final mapApi = MapApi(
    height: 1,
    onCellSelected: (cell) {},
    notifier: MapNotifier(),
  );

  onCustomizeMap(mapApi);
  final actions = mapApi.getMapActions(troopRef: troop, team: Team.white);

  expect(actions.length, expectedActions.length, reason: "Actions length");
  for (final currentAction in actions) {
    expect(
      expectedActions.contains(currentAction),
      true,
      reason: "expected Action does not contain: $currentAction",
    );
  }
}
