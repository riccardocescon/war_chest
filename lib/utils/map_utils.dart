import 'package:flutter/cupertino.dart';

class MapUtils {
  static double getMapHeigth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandScape ? width * 0.446 : (width / 1.5);
  }
}
