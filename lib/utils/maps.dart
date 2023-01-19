import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/widgets/cell.dart';
import 'package:war_chest/utils/extentions.dart';
import 'dart:math' as math;

enum MapType {
  standard,
  filled,
}

extension MapHelper on MapType {
  static const MapCellType e = MapCellType.empty;
  static const MapCellType n = MapCellType.normal;
  static const MapCellType z = MapCellType.zone;
  static const MapCellType t = MapCellType.team;
  static const MapCellType s = MapCellType.teamZone;
  static const MapCellType w = MapCellType.whiteZone;
  static const MapCellType b = MapCellType.blackZone;
  Iterable<MapCellType> get cells {
    final maps = {
      MapType.standard: [
        e, e, e, e, b, n, n, e, e, e, e, //
        e, e, n, n, n, n, n, b, n, e, e, //
        t, s, n, z, n, n, z, n, z, t, s, //
        s, t, z, n, z, n, n, n, n, t, t, //
        e, t, n, n, n, n, n, z, n, s, e, //
        e, e, e, n, n, n, w, n, e, e, e, //
        e, e, e, e, e, n, e, e, e, e, e, //
      ],
      MapType.filled: [
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
        n, n, n, n, n, n, n, n, n, n, n, //
      ],
    };

    return maps[this]!;
  }

  int get mapWidth {
    final maps = {
      MapType.standard: 11,
      MapType.filled: 11,
    };

    return maps[this]!;
  }

  int get mapHeight {
    final maps = {
      MapType.standard: 7,
      MapType.filled: 7,
    };

    return maps[this]!;
  }
}

class Maps {
  static List<Cell> getMap({
    required void Function(Cell) onCellSelected,
    required MapType map,
  }) {
    final mapWidth = map.mapWidth;
    final mapHeight = map.mapHeight;
    int cellId = 1;
    final cells = <Cell>[];
    for (int w = 0; w < mapWidth; w++) {
      for (int h = 0; h < mapHeight; h++) {
        final pos = h * mapWidth + w;
        final i = w * mapHeight + h;
        if (map.cells.elementAt(pos) == MapCellType.empty) continue;

        final cell = Cell.fromType(
          id: cellId,
          mapCoords: i,
          type: map.cells.elementAt(pos),
          onCellSelected: onCellSelected,
        );
        cellId++;
        cells.add(cell);
      }
    }

    // Add the cell neighbours
    for (final currentCell in cells) {
      final neighbours = <int>[];
      int cell = currentCell.mapCoords;
      final column = cell ~/ mapHeight;
      for (int sign = -1; sign < 2; sign += 2) {
        // Top and Bottom
        final cellIdToAdd = cell + sign;
        final isSameColumn = cellIdToAdd ~/ mapHeight == column;
        if (isSameColumn) {
          final cellExists = cells.any(
            (element) => element.mapCoords == cellIdToAdd,
          );
          if (cellExists) {
            neighbours.add(cellIdToAdd);
          }
        }
        // pari :    {n + 1, n - 1, n + mapHeigth, n - mapHeigth, n + mapHeigth + 1, n - mapHeigth + 1}
        // dispari : {n + 1, n - 1, n + mapHeigth, n - mapHeigth, n + mapHeigth - 1, n - mapHeigth - 1}
        for (int i = 0; i < 2; i++) {
          final cellIdToAdd =
              cell + map.mapHeight * sign + i * math.pow(-1, column).toInt();
          final isCorrectColumn = cellIdToAdd ~/ mapHeight == column + sign;
          if (!isCorrectColumn) continue;

          final cellExists = cells.any(
            (element) => element.mapCoords == cellIdToAdd,
          );
          if (cellExists) {
            neighbours.add(cellIdToAdd);
          }
        }
      }

      final neighboursCells = <Cell>[];
      for (final currentCoord in neighbours) {
        final cell = cells.firstWhereNullable(
          (element) => element.mapCoords == currentCoord,
        );
        if (cell != null) {
          neighboursCells.add(cell);
        }
      }

      currentCell.neighbors.addAll(neighboursCells);
    }

    return cells;
  }
}
