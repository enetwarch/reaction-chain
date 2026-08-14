import 'package:reaction_chain/data/player.dart';

typedef Coordinates = ({int row, int col});

class Board {
  int rows;
  int cols;
  List<List<Cell>> cells;

  Board({required this.rows, required this.cols})
    : cells = List.generate(rows, (row) {
        return List.generate(cols, (col) {
          return Cell(
            criticalMass: _criticalMassFor(row, col, rows, cols),
            coordinates: (row: row, col: col),
          );
        });
      });

  static int _criticalMassFor(int row, int col, int rows, int cols) {
    final isTopOrBottom = row == 0 || row == rows - 1;
    final isLeftOrRight = col == 0 || col == cols - 1;

    if (isTopOrBottom && isLeftOrRight) return 2;
    if (isTopOrBottom || isLeftOrRight) return 3;
    return 4;
  }

  bool isValidCoordinates(Coordinates coordinates) {
    return coordinates.row >= 0 &&
        coordinates.row < rows &&
        coordinates.col >= 0 &&
        coordinates.col < cols;
  }

  Cell? cell(Coordinates coordinates) {
    return isValidCoordinates(coordinates)
        ? cells[coordinates.row][coordinates.col]
        : null;
  }

  List<Cell> getNeighbors(Coordinates coordinates) {
    final candidates = [
      (row: coordinates.row - 1, col: coordinates.col), // up
      (row: coordinates.row + 1, col: coordinates.col), // down
      (row: coordinates.row, col: coordinates.col - 1), // left
      (row: coordinates.row, col: coordinates.col + 1), // right
    ];

    return candidates.map(cell).whereType<Cell>().toList();
  }
}

class Cell {
  Player? occupant;
  int criticalMass;
  int orbCount;
  Coordinates coordinates;

  Cell({
    this.occupant,
    this.orbCount = 0,
    required this.criticalMass,
    required this.coordinates,
  });

  bool get isCornerCell => criticalMass == 2;
  bool get isEdgeCell => criticalMass == 3;
  bool get isInteriorCell => criticalMass == 4;

  bool get isCritical => orbCount >= criticalMass;
  bool get isEmpty => orbCount == 0;
}

// For chain reactions.
class ExplosionEvent {
  final Coordinates source;
  final Player? owner;
  final List<Coordinates> affectedNeighbors;

  ExplosionEvent({
    required this.source,
    required this.owner,
    required this.affectedNeighbors,
  });
}
