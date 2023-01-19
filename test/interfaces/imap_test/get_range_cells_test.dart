import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/interfaces/imap.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/maps.dart';
import 'package:war_chest/widgets/cell.dart';

class FakeMap extends IMap {
  FakeMap() {
    cells.addAll(
      Maps.getMap(
        onCellSelected: (cell) {},
        map: MapType.filled,
      ),
    );
  }

  @override
  List<Cell> canMove(Troop troop, Cell troopCell) {
    return [];
  }

  @override
  final List<Cell> cells = [];
}

void main() {
  group("Odd Column", () {
    test(
      "Odd _getRangeCells range 1",
      () => _getRangeCells(
        pivotId: 52,
        range: 1,
        rangeCells: [51, 44, 45, 53, 59, 58],
      ),
    );

    test("Odd _getRangeCells range 2", () {
      _getRangeCells(
        pivotId: 52,
        range: 2,
        rangeCells: [
          50,
          43,
          37,
          38,
          39,
          46,
          54,
          60,
          67,
          66,
          65,
          57,
        ],
      );
    });

    test("Odd _getRangeCells range 4", () {
      _getRangeCells(
        pivotId: 60,
        range: 4,
        rangeCells: [56, 50, 43, 37, 30, 31, 32, 33, 34, 71, 64],
      );
    });
  });

  group("Even Column", () {
    test(
      "Even _getRangeCells range 1",
      () => _getRangeCells(
        pivotId: 38,
        range: 1,
        rangeCells: [37, 30, 31, 39, 45, 44],
      ),
    );
    test(
      "Even _getRangeCells range 2",
      () => _getRangeCells(
        pivotId: 30,
        range: 2,
        rangeCells: [28, 22, 15, 16, 17, 25, 32, 39, 45, 44, 43, 36],
      ),
    );

    test(
      "Even _getRangeCells range 3",
      () => _getRangeCells(
        pivotId: 30,
        range: 3,
        rangeCells: [
          21,
          14,
          8,
          9,
          10,
          11,
          18,
          26,
          33,
          40,
          46,
          53,
          52,
          51,
          50,
          42,
          35
        ],
      ),
    );

    test(
      "Even Map Corner",
      () => _getRangeCells(
        pivotId: 0,
        range: 3,
        rangeCells: [3, 10, 16, 23, 22, 21],
      ),
    );
  });
}

void _getRangeCells({
  required int pivotId,
  required int range,
  required Iterable<int> rangeCells,
}) {
  final map = FakeMap();

  final cells = map.getRangeCells(
    pivot: map.cells.firstWhere((element) => element.mapCoords == pivotId),
    range: range,
  );

  expect(cells.length, rangeCells.length);
  for (final current in cells) {
    expect(
      rangeCells.contains(current.mapCoords),
      true,
      reason: "Cell ${current.mapCoords} not found",
    );
  }
}
