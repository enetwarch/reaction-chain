import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/game_state.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/services/local_storage.dart';

class GameController extends ChangeNotifier {
  static const defaultRows = 9;
  static const defaultCols = 6;

  final GameState state;
  final LocalStorage localStorage;

  GameController({
    required List<Player> players,
    required this.localStorage,
    Board? board,
  }) : state = GameState(
         board: board ?? Board(rows: defaultRows, cols: defaultCols),
         players: players,
       );

  GameController.fromState(this.state, {required this.localStorage});

  Board get board => state.board;
  List<Player> get players => List.unmodifiable(state.players);
  List<Move> get moves => List.unmodifiable(state.moves);
  int get turnNumber => state.turnNumber;
  Player get currentPlayer => state.currentPlayer;
  bool get hasWinner => state.hasWinner;
  bool get hasUnstableCells =>
      board.cells.any((row) => row.any((cell) => cell.isCritical));

  void refresh() => notifyListeners();

  bool placeOrb(Coordinates coordinates) {
    if (hasWinner) return false;
    final cell = board.cell(coordinates)!;
    if (cell.occupant != null && cell.occupant != currentPlayer) return false;

    cell.occupant = currentPlayer;
    cell.orbCount++;
    currentPlayer.hasMoved = true;
    state.moves.add((player: currentPlayer, coordinates: coordinates));

    notifyListeners();
    return true;
  }

  List<ExplosionEvent> stepExplosions() {
    final unstable = [
      for (final row in board.cells)
        for (final cell in row)
          if (cell.isCritical) cell.coordinates,
    ];

    final events = <ExplosionEvent>[];
    for (final coordinates in unstable) {
      final cell = board.cell(coordinates)!;
      cell.orbCount -= cell.criticalMass;
      if (cell.orbCount <= 0) {
        cell.occupant = null;
      }

      final neighbors = board.getNeighbors(coordinates);
      for (final neighbor in neighbors) {
        neighbor.occupant = currentPlayer;
        neighbor.orbCount++;
      }

      events.add(
        ExplosionEvent(
          owner: currentPlayer,
          source: coordinates,
          affectedNeighbors: neighbors
              .map((neighbor) => neighbor.coordinates)
              .toList(),
        ),
      );
    }

    _recalculatePlayerOrbCounts();
    notifyListeners();
    return events;
  }

  void endTurn() {
    _recalculatePlayerOrbCounts();
    _nextTurn();
    _saveState();
    notifyListeners();
  }

  void resignCurrentPlayer() {
    if (!currentPlayer.isOut) {
      currentPlayer.isOut = true;
    }

    _nextTurn();
    _saveState();
  }

  Future<void> _saveState() {
    return hasWinner
        ? localStorage.clearGameState()
        : localStorage.saveGameState(state);
  }

  void _nextTurn() {
    state.turnNumber++;
    state.turnPointer = (state.turnPointer + 1) % players.length;
    while (currentPlayer.isOut) {
      state.turnPointer = (state.turnPointer + 1) % players.length;
    }
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
