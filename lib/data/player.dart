import 'dart:math';

import 'package:flutter/material.dart';

enum PlayerType { human, bot }

enum PlayerColor {
  red,
  green,
  blue,
  yellow;

  String get label => switch (this) {
    PlayerColor.red => 'Red',
    PlayerColor.green => 'Green',
    PlayerColor.blue => 'Blue',
    PlayerColor.yellow => 'Yellow',
  };

  static PlayerColor random({PlayerColor? exclude}) {
    final options = values.where((c) => c != exclude).toList();
    return options[Random().nextInt(options.length)];
  }
}

// The sealed keyword makes it unextendable on other files.
sealed class Player {
  PlayerColor color;
  int orbCount;
  bool hasMoved;
  bool isOut;

  Player({
    required this.color,
    this.orbCount = 0,
    this.hasMoved = false,
    this.isOut = false,
  });

  String get displayColor => switch (color) {
    PlayerColor.red => "Red",
    PlayerColor.green => "Green",
    PlayerColor.blue => "Blue",
    PlayerColor.yellow => "Yellow",
  };

  String get displayName;
  IconData get displayIcon;
}

class HumanPlayer extends Player {
  String name;

  HumanPlayer({required super.color, required this.name});

  @override
  String get displayName => name;
  @override
  IconData get displayIcon => Icons.person_rounded;
}

class BotPlayer extends Player {
  int level;

  BotPlayer({required super.color, required this.level});

  @override
  String get displayName => 'Level $level';
  @override
  IconData get displayIcon => Icons.smart_toy_rounded;
}
