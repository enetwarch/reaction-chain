import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/player.dart';

typedef Move = ({Player player, Coordinates coordinates});

class GameState {
  final Board board;
  final List<Player> players;
  final List<Move> moves;
  int turnNumber;
  int turnPointer;

  GameState({
    required this.board,
    required this.players,
    List<Move>? moves,
    this.turnNumber = 1,
    this.turnPointer = 0,
  }) : moves = moves ?? [];

  Player get currentPlayer => players[turnPointer];

  bool get hasWinner =>
      players.length > 1 &&
      players.where((player) => !player.isOut).length == 1;

  Map<String, dynamic> toJson() => {
    'players': players.map((player) => player.toJson()).toList(),
    'board': board.toJson(),
    'moves': moves
        .map(
          (move) => {
            'playerColor': move.player.color.name,
            'coordinates': move.coordinates.toJson(),
          },
        )
        .toList(),
    'turnNumber': turnNumber,
    'turnPointer': turnPointer,
  };

  factory GameState.fromJson(Map<String, dynamic> json) {
    final players = (json['players'] as List)
        .map((player) => Player.fromJson(player as Map<String, dynamic>))
        .toList();

    final board = Board.fromJson(
      json['board'] as Map<String, dynamic>,
      players: players,
    );

    final moves =
        (json['moves'] as List?)?.map((moveJson) {
          final moveMap = moveJson as Map<String, dynamic>;
          final colorName = moveMap['playerColor'] as String?;

          final player = players.firstWhere(
            (player) => player.color.name == colorName,
          );
          final coordinates = CoordinatesExtension.fromJson(
            moveMap['coordinates'] as Map<String, dynamic>,
          );

          return (player: player, coordinates: coordinates);
        }).toList() ??
        [];

    return GameState(
      board: board,
      players: players,
      moves: moves,
      turnNumber: json['turnNumber'] as int? ?? 1,
      turnPointer: json['turnPointer'] as int? ?? 0,
    );
  }
}
