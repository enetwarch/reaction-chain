import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/player.dart';

class GameController extends ChangeNotifier {
  static const defaultRows = 9;
  static const defaultCols = 6;
  // There is a potential for other game modes.

  final List<Player> _players;
  final Board board;

  GameController({required List<Player> players, Board? board})
    : _players = players,
      board = board ?? Board(rows: defaultRows, cols: defaultCols);

  List<Player> get players => List.unmodifiable(_players);

  int turn = 0;
  Player get currentPlayer => _players[turn];

  List<ExplosionEvent> placeOrb(Coordinates coordinates) {
    final cell = board.cell(coordinates)!;
    if (cell.occupant != null && cell.occupant != currentPlayer) return [];

    cell.occupant = currentPlayer;
    cell.orbCount++;

    final events = _chainReaction(coordinates);
    _nextTurn();
    _recalculatePlayerOrbCounts();
    notifyListeners();

    return events;
  }

  void _nextTurn() {
    turn = (turn + 1) % players.length;
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
  }
}
