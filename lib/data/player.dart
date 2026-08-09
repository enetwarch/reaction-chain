enum PlayerColor { red, green, blue, yellow }

// The sealed keyword makes it unextendable on other files.
sealed class Player {
  final PlayerColor color;

  Player({required this.color});
}

class HumanPlayer extends Player {
  final String name;

  HumanPlayer({required super.color, required this.name});
}

class BotPlayer extends Player {
  final int level;

  BotPlayer({required super.color, required this.level});
}
