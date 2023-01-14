import 'package:flutter_test/flutter_test.dart';
import 'package:war_chest/utils/maps.dart';
import 'package:war_chest/widgets/cell.dart';

void main() {
  test('getStandardMap', _getStandardMap);
}

void _getStandardMap() {
  List<Cell> cells = Maps.getMap(
    onCellSelected: (_) {},
    map: MapType.standard,
  );
  final ids = <int>[
    2,
    3,
    9,
    10,
    11,
    15,
    16,
    17,
    18,
    22,
    23,
    24,
    25,
    26,
    28,
    29,
    30,
    31,
    32,
    33,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    50,
    51,
    25,
    53,
    54,
    57,
    58,
    59,
    60,
    65,
    66,
    67,
    72,
    73,
  ];

  expect(cells.length, ids.length,
      reason: 'The number of cells is not correct');
  for (int i = 0; i < ids.length; i++) {
    expect(
      cells.map((e) => e.mapCoords).contains(ids[i]),
      true,
      reason: 'The cell with id $i is not correct',
    );
  }

  final cell2 = cells.firstWhere((e) => e.mapCoords == 2);
  final expected2 = [3, 9, 10];
  expect(cell2.neighbors.length, expected2.length);
  for (final current in expected2) {
    expect(cell2.neighbors.map((e) => e.mapCoords).contains(current), true);
  }

  final cell37 = cells.firstWhere((e) => e.mapCoords == 37);
  final expected37 = [29, 30, 36, 38, 43, 44];
  expect(cell37.neighbors.length, expected37.length);
  for (final current in expected37) {
    expect(cell37.neighbors.map((e) => e.mapCoords).contains(current), true);
  }
}
