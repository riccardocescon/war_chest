import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:war_chest/clippers/bag_clipper.dart';
import 'package:war_chest/models/commander.dart';
import 'package:war_chest/models/troops/troop.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key, required this.commander});

  final Commander commander;

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.25,
      color: Colors.grey.shade900,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: _supply(),
              ),
              _handUI(),
            ],
          ),
          _bagUI(),
          _garrisonUI(),
        ],
      ),
    );
  }

  Widget _supply() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.commander.supplyMap.entries
          .map((entry) => _singleSupply(entry.key, entry.value))
          .toList(),
    );
  }

  List<Widget> _stacketTroops(Troop<dynamic> troopType, int supplyAmount) {
    List<Widget> troops = [];
    for (int i = 0; i < supplyAmount; i++) {
      troops.add(
        Transform.translate(
          offset: Offset(0, -i * 8.0),
          child: _troop(troopType, shadow: true),
        ),
      );
    }
    return troops;
  }

  Widget _singleSupply(Troop<dynamic> troopType, int supplyAmount) {
    List<Widget> troops = _stacketTroops(troopType, supplyAmount);
    return SizedBox(
      height: height * 0.07,
      child: MaterialButton(
        color: Colors.grey.shade800,
        onPressed: () {
          log('Pressed ${troopType.runtimeType} supply');
        },
        child: Stack(
          children: troops,
        ),
      ),
    );
  }

  Widget _handUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.commander.hand
          .map(
            (troop) => _troop(
              troop,
              shadow: true,
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.purple,
                onPressed: () {},
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _troop(Troop troop,
      {Widget? child, bool shadow = false, double? size}) {
    return Container(
      width: size ?? width * 0.12,
      height: size ?? width * 0.12,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(100),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: troop.draw(
        width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: child,
        ),
      ),
    );
  }

  Widget _bagUI() {
    return Positioned(
      left: width * 0.04,
      bottom: height * 0.001,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: BagClipper(),
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, height * 0.008),
            child: Text(
              widget.commander.bagSize.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _garrisonUI() {
    // Get all entries on Garrison Map
    // Convert this to a List of Tuple with Troops sorted by Type
    final entries = widget.commander.garrisonMap.entries.toList();

    // If ods, get last troop and remove it from entries
    Troop? lastTroop;
    if (entries.length % 2 != 0) {
      lastTroop = entries.last.key;
      entries.removeLast();
    }

    // Save tuples
    final Map<Troop, Troop?> types = {};
    for (int i = 0; i < entries.length; i += 2) {
      types.addAll({entries.elementAt(i).key: entries.elementAt(i + 1).key});
    }

    // Add last troop if exists
    if (lastTroop != null) {
      types.addAll({lastTroop: null});
    }
    const garrisonHeigth = 70.0;
    const rowHeigth = garrisonHeigth / 3;
    return Positioned(
      right: width * 0.04,
      bottom: height * 0.001,
      child: SizedBox(
        width: garrisonHeigth,
        height: garrisonHeigth,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: MaterialButton(
            onPressed: () {},
            padding: const EdgeInsets.all(0),
            color: Colors.grey.shade800,
            child: Column(
              children: List.generate(
                types.length,
                (index) => _garrisonRow(
                  rowHeigth,
                  types.keys.elementAt(index),
                  entries[index].value,
                  types.values.elementAt(index),
                  types.values.elementAt(index) == lastTroop
                      ? null
                      : entries[index].value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _garrisonRow(
    double size,
    Troop firstType,
    int firstSize,
    Troop? secondTroop,
    int? secondSize,
  ) {
    return Row(
      children: [
        _garrisonItem(size, firstType, firstSize),
        if (secondTroop != null) _garrisonItem(size, secondTroop, secondSize!),
      ],
    );
  }

  Widget _garrisonItem(double size, Troop troop, int amount) {
    List<Widget> troops = [];
    for (int i = 0; i < amount; i++) {
      troops.add(
        Transform.translate(
          offset: Offset(0, -i * 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: troop.draw(size),
          ),
        ),
      );
    }
    return Expanded(
      child: SizedBox(
          height: size,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: troops,
          )),
    );
  }
}
