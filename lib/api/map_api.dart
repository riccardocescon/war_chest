import 'package:flutter/material.dart';
import 'package:war_chest/interfaces/imap.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/maps.dart';
import 'package:war_chest/widgets/cell.dart';
import 'package:war_chest/widgets/standard_map.dart';

class MapApi<M extends StandardMap> extends StatelessWidget with IMap {
  MapApi({
    super.key,
    required this.height,
    required this.onCellSelected,
    required this.notifier,
  }) {
    cells.addAll(
      Maps.getMap(
        onCellSelected: onCellSelected,
        map: MapType.standard,
      ),
    );
    map = StandardMap(
      height: height,
      onCellSelected: onCellSelected,
      notifier: notifier,
      cells: cells,
    );
  }

  final double height;
  final void Function(Cell) onCellSelected;
  final MapNotifier notifier;
  late final StandardMap map;

  @override
  Widget build(BuildContext context) => map;

  @override
  List<Cell> canMove(Troop troop, Cell cell) {
    final destinationCells = getRangeCells(pivot: cell, range: 1).toList();
    destinationCells.removeWhere((element) => element.isBusy);
    return destinationCells;
  }
}
