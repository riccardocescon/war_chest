import 'package:flutter/material.dart';
import 'package:war_chest/clippers/hexagon_clipper.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/utils/map_utils.dart';

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
    this.isTeamMode = false,
    this.isZone = false,
    this.claimedBy,
    required this.onCellSelected,
  });

  final int id;
  final bool isTeamMode;
  final bool isZone;
  final Team? claimedBy;

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
      return finalHexagon();
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
