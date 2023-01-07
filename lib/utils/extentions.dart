import 'package:war_chest/models/troops/troop.dart';

extension TroopMap<T extends Troop> on Map<T, List<T>> {
  bool containsTroopType(T troop) {
    for (T troopType in keys) {
      if (troopType.runtimeType == troop.runtimeType) {
        return true;
      }
    }
    return false;
  }

  List<T> getTroopType(T troop) {
    for (T troopType in keys) {
      if (troopType.runtimeType == troop.runtimeType) {
        return this[troopType]!;
      }
    }
    throw Exception('Map does not contain this troop type');
  }
}
