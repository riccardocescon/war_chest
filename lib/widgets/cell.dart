import 'package:flutter/material.dart';
import 'package:war_chest/clippers/hexagon_clipper.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/utils/map_utils.dart';
import 'package:war_chest/utils/extentions.dart';

class CellNotifier extends ChangeNotifier {
  void onUpdate() {
    notifyListeners();
  }

  Troop? troop;
  void onTroopUpdate(Troop? newTroop) {
    troop = newTroop;
    notifyListeners();
  }
}

class Cell extends StatefulWidget {
  Cell({
    super.key,
    required this.id,
    this.mapCoords = -1,
    this.isTeamMode = false,
    this.isZone = false,
    this.claimedBy,
    required this.onCellSelected,
  });

  Cell.fromType({
    super.key,
    required this.id,
    required this.mapCoords,
    required MapCellType type,
    required this.onCellSelected,
  }) {
    switch (type) {
      case MapCellType.empty:
        isTeamMode = false;
        isZone = false;
        claimedBy = null;
        break;
      case MapCellType.normal:
        isTeamMode = false;
        isZone = false;
        claimedBy = null;
        break;
      case MapCellType.zone:
        isTeamMode = false;
        isZone = true;
        claimedBy = null;
        break;
      case MapCellType.team:
        isTeamMode = true;
        isZone = false;
        claimedBy = null;
        break;
      case MapCellType.teamZone:
        isTeamMode = true;
        isZone = true;
        claimedBy = null;
        break;
      case MapCellType.whiteZone:
        isTeamMode = true;
        isZone = true;
        claimedBy = Team.white;
        break;
      case MapCellType.blackZone:
        isTeamMode = true;
        isZone = true;
        claimedBy = Team.black;
        break;
    }
  }

  final int id;
  final int mapCoords;
  late final bool isTeamMode;
  late final bool isZone;
  late final Team? claimedBy;
  final List<Cell> neighbors = <Cell>[];

  final void Function(Cell) onCellSelected;
  final CellNotifier notifier = CellNotifier();

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  double get hexSize => MapUtils.getMapHeigth(context) / 7;

  @override
  void initState() {
    widget.notifier.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifier.troop == null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          finalHexagon(),
          Text(
            widget.mapCoords.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          finalHexagon(),
          IgnorePointer(
            child: widget.notifier.troop!.draw(hexSize),
          ),
        ],
      );
    }
  }

  Widget _hexagon(double size) => Center(
        child: ClipPath(
          clipper: HexagonClipper(),
          child: SizedBox(
            width: size,
            height: size,
            child: MaterialButton(
              onPressed: () => _handleSelection(),
              splashColor: Colors.deepPurple,
              color: widget.isTeamMode
                  ? Colors.amber.shade800
                  : Colors.amber.shade200,
            ),
          ),
        ),
      );

  Widget finalHexagon() {
    if (widget.claimedBy != null && widget.isZone) {
      return _claimedHexagon(hexSize, widget.claimedBy!);
    }
    final size = hexSize;

    if (!widget.isZone) {
      return _hexagon(size);
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          _hexagon(size),

          // Border Circle
          IgnorePointer(
            child: Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
            ),
          ),

          // Filled Circle
          IgnorePointer(
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _claimedHexagon(double size, Team claimedBy) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: HexagonClipper(),
          child: SizedBox(
            width: size,
            height: size,
            child: MaterialButton(
              onPressed: () => _handleSelection(),
              splashColor: Colors.deepPurple,
              color: claimedBy.color,
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              color: claimedBy.insetBorderColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: BoxDecoration(
              color: claimedBy.centerColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSelection() {
    widget.onCellSelected(widget);
  }
}
