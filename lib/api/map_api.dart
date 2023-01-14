import 'package:flutter/material.dart';
import 'package:war_chest/widgets/standard_map.dart';

class MapApi<M extends StandardMap> extends StatelessWidget {
  const MapApi({super.key, required this.map});

  final StandardMap map;

  @override
  Widget build(BuildContext context) {
    return map;
  }
}
