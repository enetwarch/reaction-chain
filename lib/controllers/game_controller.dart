import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/game_state.dart';
import 'package:reaction_chain/data/player.dart';

class GameController extends ChangeNotifier {
  static const defaultRows = 9;
  static const defaultCols = 6;

  final GameState state;

  // New game constructor
  GameController({required List<Player> players, Board? board})
    : state = GameState(
        board: board ?? Board(rows: defaultRows, cols: defaultCols),
        players: players,
      );

  // Resume game from state constructor
  GameController.fromState(this.state);

  Board get board => state.board;
  List<Player> get players => List.unmodifiable(state.players);
  List<Move> get moves => List.unmodifiable(state.moves);
  int get turnNumber => state.turnNumber;
  Player get currentPlayer => state.currentPlayer;
  bool get hasWinner => state.hasWinner;

  void refresh() => notifyListeners();

  List<ExplosionEvent> placeOrb(Coordinates coordinates) {
    if (hasWinner) return [];
    final cell = board.cell(coordinates)!;
    if (cell.occupant != null && cell.occupant != currentPlayer) return [];

    cell.occupant = currentPlayer;
    cell.orbCount++;
    currentPlayer.hasMoved = true;
    state.moves.add((player: currentPlayer, coordinates: coordinates));

    final events = _chainReaction(coordinates);
    _recalculatePlayerOrbCounts();
    _nextTurn();

    return events;
  }

  void _nextTurn() {
    state.turnNumber++;
    state.turnPointer = (state.turnPointer + 1) % players.length;
    while (currentPlayer.isOut) {
      state.turnPointer = (state.turnPointer + 1) % players.length;
    }
  }

  List<ExplosionEvent> _chainReaction(Coordinates coordinates) {
    final events = <ExplosionEvent>[];
    final queue = Queue<Coordinates>()..add(coordinates);

    while (queue.isNotEmpty) {
      final coords = queue.removeFirst();
      final cell = board.cell(coords)!;
      if (!cell.isCritical) continue;

      final owner = cell.occupant;
      cell.orbCount -= cell.criticalMass;
      if (cell.orbCount <= 0) {
        cell.occupant = null;
      }

      final neighbors = board.getNeighbors(coords);
      for (final neighbor in neighbors) {
        neighbor.occupant = owner;
        neighbor.orbCount++;

        if (neighbor.isCritical) {
          queue.add(neighbor.coordinates);
        }
      }

      events.add(
        ExplosionEvent(
          owner: owner,
          source: coords,
          affectedNeighbors: neighbors
              .map((neighbor) => neighbor.coordinates)
              .toList(),
        ),
      );
    }

    return events;
  }

  void _recalculatePlayerOrbCounts() {
    for (final player in state.players) {
      player.orbCount = 0;
    }

    for (final row in board.cells) {
      for (final cell in row) {
        final owner = cell.occupant;
        if (owner != null) {
          owner.orbCount += cell.orbCount;
        }
      }
    }

    for (final player in state.players) {
      if (player.hasMoved && player.orbCount <= 0) {
        player.isOut = true;
      }
    }
  }
}
