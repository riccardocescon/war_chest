import 'package:war_chest/models/troops/guardian.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/widgets/cell.dart';
import 'package:war_chest/utils/extentions.dart';

abstract class IMap {
  final List<Cell> cells = [];
  List<Cell> get cellsWithTroops =>
      cells.where((element) => element.notifier.troop != null).toList();

  //#region Overrides

  bool canMove(Troop troop, Cell cell);

  //#endregion

  List<GameAction> getMapActions(Troop troop) {
    final actions = <GameAction>[];
    final canDeploy = _isTroopDeployable(troop);
    if (canDeploy) {
      actions.add(GameAction.deploy);
    } else {
      actions.addAll(_handleSpecialDeploy(troop));
      // There is already a troop of this type on the map

    }

    return actions;
  }

  bool _isTroopDeployable(Troop troop) {
    return !cellsWithTroops.any(
      (element) => element.notifier.troop.runtimeType == troop.runtimeType,
    );
  }

  List<GameAction> _handleSpecialDeploy(Troop troop) {
    // Infrantry can be deployed twice
    if (troop is Infantry) {
      final infantryDeployed = cellsWithTroops
          .where((element) => element.notifier.troop is Infantry)
          .length;
      if (infantryDeployed < 2) {
        return [GameAction.deploy];
      }
    }
    return [];
  }

  List<Cell> getRangeCells({
    required Cell pivot,
    required int range,
  }) {
    List<Cell> temp = [pivot];
    List<Cell> buff = pivot.neighbors;
    for (int i = 1; i < range; i++) {
      // final externalData = buff.toList();
      temp = temp + buff;
      // temp.removeWhere((element) => oldData.contains(element));
      buff.addAll(
        buff.expand((element) => element.neighbors).toList(),
      );
      buff = buff.removeDuplicates();
      buff.removeWhere((element) => temp.contains(element));
    }

    return buff;

    // final range1 = pivot.neighbors;
    // final range2 = range1
    //     .expand((element) => element.neighbors)
    //     .toList()
    //     .removeDuplicates()
    //   ..removeWhere((element) => range1.contains(element));
    // final range3 = range2
    //     .expand((element) => element.neighbors)
    //     .toList()
    //     .removeDuplicates()
    //   ..removeWhere((element) => range1.contains(element))
    //   ..removeWhere((element) => range2.contains(element));
    // final range4 = range3
    //     .expand((element) => element.neighbors)
    //     .toList()
    //     .removeDuplicates()
    //   ..removeWhere((element) => range1.contains(element))
    //   ..removeWhere((element) => range2.contains(element))
    //   ..removeWhere((element) => range3.contains(element));
  }
}
