import 'package:war_chest/models/troops/guardian.dart';
import 'package:war_chest/models/troops/troop.dart';
import 'package:war_chest/models/troops/warden.dart';
import 'package:war_chest/utils/enums.dart';
import 'package:war_chest/widgets/cell.dart';
import 'package:war_chest/utils/extentions.dart';

abstract class IMap {
  final List<Cell> cells = [];
  List<Cell> get cellsWithTroops =>
      cells.where((element) => element.notifier.troop != null).toList();

  //#region Overrides

  List<Cell> canMove(Troop troop, Cell cell);

  //#endregion

  //#region Action Generation
  List<GameAction> getMapActions(
      {required Troop troopRef, required Team team}) {
    final actions = <GameAction>[];
    final canDeploy = _isTroopDeployable(troopRef);
    if (canDeploy) {
      /// Deploy Action
      actions.add(GameAction.deploy);
    } else {
      // There is already a troop of this type on the map

      // Check if the troop can be deployed twice
      actions.addAll(_handleSpecialDeploy(troopRef));

      /// Reinforce Action
      actions.add(GameAction.reinforce);

      final troopCell = cellsWithTroops
          .firstWhere((element) => element.notifier.troop == troopRef);

      if (troopCell.isZone && troopCell.claimedBy != team) {
        /// Claim Action
        actions.add(GameAction.claim);
      }

      final freeReachableCells = canMove(troopRef, troopCell);
      if (freeReachableCells.isNotEmpty) {
        /// Move Action
        actions.add(GameAction.move);
      }

      final nearcells = troopCell.neighbors;
      if (nearcells.any((element) => element.notifier.troop != null)) {
        /// Attack Action
        actions.add(GameAction.attack);

        _handleSpecialAttacks(troopRef, nearcells, actions);
      }

      // TODO : Add Tactis
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

  void _handleSpecialAttacks(
      Troop troop, Iterable<Cell> nearCells, List<GameAction> actionsRef) {
    final enemyCells =
        nearCells.where((element) => element.notifier.troop != null);

    // Warden can only be attacked by a troop with a reiforce level of min 2
    if (enemyCells.length == 1 && enemyCells.first.notifier.troop is Warden) {
      if (troop.reiforceLevel < 2) {
        actionsRef.removeWhere((element) => element == GameAction.attack);
      }
    }
  }
  //#endregion

  //#region Helpers
  List<Cell> getRangeCells({
    required Cell pivot,
    required int range,
  }) {
    List<Cell> temp = [pivot];
    List<Cell> buff = pivot.neighbors;
    for (int i = 1; i < range; i++) {
      temp = temp + buff;
      buff.addAll(
        buff.expand((element) => element.neighbors).toList(),
      );
      buff = buff.removeDuplicates();
      buff.removeWhere((element) => temp.contains(element));
    }

    return buff;
  }
  //#endregion

  //#region Actions

  void deploy(Troop troop, Cell cell) {
    cell.notifier.troop = troop;
  }

  void reinforce(Troop troop, Cell cell) {
    troop.reiforceLevel++;
  }

  void claim(Cell cell, Team? team) {
    cell.claimedBy = team;
  }

  void move(Troop troop, Cell from, Cell to) {
    from.notifier.troop = null;
    to.notifier.troop = troop;
  }

  void attack(Cell from, Cell to) {
    final enemyTroop = to.notifier.troop;
    if (enemyTroop == null) {
      throw Exception('No enemy troop to attack');
    }

    enemyTroop.reiforceLevel--;
    if (enemyTroop.reiforceLevel == 0) {
      from.notifier.troop = null;
    }
  }

  //#endregion

}
