import 'package:flutter/material.dart';
import 'package:war_chest/models/troops/marshal.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/utils/map_utils.dart';
import 'package:war_chest/widgets/cell.dart';

class MapNotifier extends ChangeNotifier {
  Cell? _startingCell;
  Cell? _targetCell;
  void onMove(Cell startingCell, Cell targetCell) {
    _startingCell = startingCell;
    _targetCell = targetCell;
    notifyListeners();
    _startingCell = null;
    _targetCell = null;
  }
}

class StandardMap extends StatefulWidget {
  const StandardMap({
    super.key,
    required this.height,
    required this.onCellSelected,
    required this.notifier,
  });

  final double height;
  final void Function(Cell) onCellSelected;
  final MapNotifier notifier;

  @override
  State<StandardMap> createState() => _StandardMapState();
}

class _StandardMapState extends State<StandardMap> {
  final List<Cell> _cells = [];

  double get mapHeigth => MapUtils.getMapHeigth(context);

  // Pre-processed data
  final List<int> _teamCells = [1, 2, 3, 4, 5, 43, 44, 45, 46, 47];
  final List<int> _zoneCells = [
    2,
    3,
    8,
    11,
    14,
    15,
    18,
    30,
    33,
    34,
    37,
    40,
    45,
    46
  ];
  final Map<int, Team> _claimedCells = <int, Team>{
    14: Team.white,
    15: Team.black,
    33: Team.white,
    34: Team.black,
  };

  @override
  void initState() {
    for (int i = 0; i < 47; i++) {
      _cells.add(_generateCell(i + 1));
    }
    widget.notifier.addListener(_handleNotification);

    super.initState();
  }

  void _handleNotification() {
    final startingCell = widget.notifier._startingCell;
    final targetCell = widget.notifier._targetCell;
    startingCell!.notifier.onUpdate();
    targetCell!.notifier.onUpdate();
  }

  Cell _generateCell(int id) {
    return Cell(
      id: id,
      isTeamMode: _teamCells.contains(id),
      isZone: _zoneCells.contains(id),
      claimedBy: _claimedCells[id],
      onCellSelected: widget.onCellSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _map(mapHeigth);
  }

  Widget _map(double height) {
    final hexSize = height / 7;
    return Stack(
      alignment: Alignment.center,
      children: [
        _centralColumn(hexSize),
        _column6(hexSize, false),
        _column6(hexSize, true),
        _column5(hexSize, false),
        _column5(hexSize, true),
        _column4(hexSize, false),
        _column4(hexSize, true),
        _column3(hexSize, false),
        _column3(hexSize, true),
        _column2(hexSize, false),
        _column2(hexSize, true),
      ],
    );
  }

  Widget _centralColumn(hexSize) => Column(
        children: List.generate(
          7,
          (index) => _cells[index + 20],
        ),
      );

  Widget _column6(hexSize, bool invert) => Transform.translate(
        offset: Offset(hexSize * 0.85 * (invert ? -1 : 1), hexSize / 2),
        child: Column(
          children: List.generate(
            6,
            (index) => _cells[index + (invert ? 14 : 27)],
          ),
        ),
      );

  Widget _column5(hexSize, bool invert) => Transform.translate(
        offset: Offset(hexSize * 0.85 * (invert ? -2 : 2), hexSize),
        child: Column(
          children: List.generate(
            5,
            (index) => _cells[index + (invert ? 9 : 33)],
          ),
        ),
      );
  Widget _column4(hexSize, bool invert) => Transform.translate(
        offset: Offset(hexSize * 0.85 * (invert ? -3 : 3), hexSize / 2 * 3),
        child: Column(
          children: List.generate(
            4,
            (index) => _cells[index + (invert ? 5 : 38)],
          ),
        ),
      );

  Widget _column3(hexSize, bool invert) => Transform.translate(
        offset: Offset(hexSize * 0.85 * (invert ? -4 : 4), hexSize * 2),
        child: Column(
          children: List.generate(
            3,
            (index) => _cells[index + (invert ? 2 : 42)],
          ),
        ),
      );

  Widget _column2(hexSize, bool invert) => Transform.translate(
        offset: Offset(hexSize * 0.85 * (invert ? -5 : 5), hexSize * 2.5),
        child: Column(
          children: List.generate(
            2,
            (index) => _cells[index + (invert ? 0 : 45)],
          ),
        ),
      );
}
