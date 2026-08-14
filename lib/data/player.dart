import 'package:flutter/material.dart';

enum PlayerColor { red, green, blue, yellow }

enum PlayerType { human, bot }

// The sealed keyword makes it unextendable on other files.
sealed class Player {
  PlayerColor color;
  int orbCount;

  Player({required this.color, this.orbCount = 0});

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
