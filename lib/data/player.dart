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

  Map<String, dynamic> toJson();

  static List<Player> get defaultPlayers => [
    HumanPlayer(name: 'Player 1', color: PlayerColor.red),
    HumanPlayer(name: 'Player 2', color: PlayerColor.green),
  ];

  /// Deserializes either a HumanPlayer or BotPlayer based on the stored 'type'
  factory Player.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    if (type == 'bot') {
      return BotPlayer.fromJson(json);
    }
    return HumanPlayer.fromJson(json);
  }
}

class HumanPlayer extends Player {
  String name;

  HumanPlayer({
    required super.color,
    required this.name,
    super.orbCount,
    super.hasMoved,
    super.isOut,
  });

  @override
  String get displayName => name;

  @override
  IconData get displayIcon => Icons.person_rounded;

  @override
  Map<String, dynamic> toJson() => {
    'type': 'human',
    'color': color.name,
    'name': name,
    'orbCount': orbCount,
    'hasMoved': hasMoved,
    'isOut': isOut,
  };

  factory HumanPlayer.fromJson(Map<String, dynamic> json) {
    return HumanPlayer(
      color: PlayerColor.values.byName(json['color'] as String),
      name: json['name'] as String,
      orbCount: json['orbCount'] as int? ?? 0,
      hasMoved: json['hasMoved'] as bool? ?? false,
      isOut: json['isOut'] as bool? ?? false,
    );
  }
}

class BotPlayer extends Player {
  int level;

  BotPlayer({
    required super.color,
    required this.level,
    super.orbCount,
    super.hasMoved,
    super.isOut,
  });

  @override
  String get displayName => 'Level $level';

  @override
  IconData get displayIcon => Icons.smart_toy_rounded;

  @override
  Map<String, dynamic> toJson() => {
    'type': 'bot',
    'color': color.name,
    'level': level,
    'orbCount': orbCount,
    'hasMoved': hasMoved,
    'isOut': isOut,
  };

  factory BotPlayer.fromJson(Map<String, dynamic> json) {
    return BotPlayer(
      color: PlayerColor.values.byName(json['color'] as String),
      level: json['level'] as int,
      orbCount: json['orbCount'] as int? ?? 0,
      hasMoved: json['hasMoved'] as bool? ?? false,
      isOut: json['isOut'] as bool? ?? false,
    );
  }
}
