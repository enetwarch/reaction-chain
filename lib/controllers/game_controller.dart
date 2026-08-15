import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/player.dart';

class GameController extends ChangeNotifier {
  static const defaultRows = 9;
  static const defaultCols = 6;
  // There is a potential for other game modes.

  final List<Move> _moves = [];
  final List<Player> _players;
  final Board board;

  GameController({required List<Player> players, Board? board})
    : _players = players,
      board = board ?? Board(rows: defaultRows, cols: defaultCols);
  // A board might be initialized elsewhere.

  List<Move> get moves => List.unmodifiable(_moves);
  List<Player> get players => List.unmodifiable(_players);

  void refresh() => notifyListeners();

  int turnNumber = 1;
  int _turnPointer = 0;
  Player get currentPlayer => _players[_turnPointer];
  bool get hasWinner =>
      _players.length > 1 &&
      _players.where((player) => !player.isOut).length == 1;

  List<ExplosionEvent> placeOrb(Coordinates coordinates) {
    if (hasWinner) return [];
    final cell = board.cell(coordinates)!;
    if (cell.occupant != null && cell.occupant != currentPlayer) return [];

    cell.occupant = currentPlayer;
    cell.orbCount++;
    currentPlayer.hasMoved = true;
    _moves.add((player: currentPlayer, coordinates: coordinates));

    final events = _chainReaction(coordinates);
    _recalculatePlayerOrbCounts();
    _nextTurn();

    return events;
  }

  void _nextTurn() {
    turnNumber++;
    _turnPointer = (_turnPointer + 1) % players.length;
    while (currentPlayer.isOut) {
      _turnPointer = (_turnPointer + 1) % players.length;
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
    for (final player in _players) {
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

    for (final player in _players) {
      if (player.hasMoved && player.orbCount <= 0) {
        player.isOut = true;
      }
    }
  }
}
