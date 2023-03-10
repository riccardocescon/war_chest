import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/map_utils.dart';
import 'package:war_chest/widgets/cell.dart';
import 'package:war_chest/widgets/standard_map.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState<T extends Troop> extends State<GamePage> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  Cell? _startingCell;
  final MapNotifier _notifier = MapNotifier();
  StandardMap? _map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          OrientationBuilder(
            builder: (context, orientation) {
              final isLandScape = orientation == Orientation.portrait;
              final mapWidth = width;
              final mapHeight = MapUtils.getMapHeigth(context);

              _map ??= StandardMap(
                height: mapHeight,
                onCellSelected: _onCellSelected,
                notifier: _notifier,
              );

              final map = Container(
                color: Colors.grey.shade900,
                child: _map,
              );
              return InteractiveViewer(
                minScale: 1,
                maxScale: 2,
                child: SizedBox(
                  width: mapWidth,
                  height: mapHeight,
                  child: isLandScape
                      ? map
                      : AspectRatio(
                          aspectRatio: isLandScape ? width / (width / 1.5) : 1,
                          child: map,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onCellSelected(Cell cell) {
    // First selection Cell
    if (_startingCell == null) {
      // Assert that the starting cell has a troop
      if (cell.notifier.troop == null) {
        return;
      }

      setState(() {
        _startingCell = cell;
      });
      return;
    }

    // Selected same cell, cancelling it
    if (_startingCell == cell) {
      setState(() {
        _startingCell = null;
      });
      return;
    }

    // Assert Troop Movement Rules
    if (!_assertTroopMovementRules(_startingCell!, cell)) {
      return;
    }

    // Move Troop
    final tempCell = _startingCell!;
    setState(() {
      cell.notifier.troop = _startingCell!.notifier.troop;
      _startingCell!.notifier.troop = null;
      _startingCell = null;
    });
    _notifier.onMove(tempCell, cell);
  }

  bool _assertTroopMovementRules(Cell startingCell, Cell targetCell) {
    return true;
  }
}
