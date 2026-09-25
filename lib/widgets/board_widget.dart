import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final void Function(Coordinates) onCellTap;

  const BoardWidget({super.key, required this.board, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          width: AppDimensions.borderSm,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          (AppDimensions.radiusSm - AppDimensions.borderSm).clamp(
            0,
            double.infinity,
          ),
        ),

        // Forcing this to be a grid was really hard, so I stuck to a
        // Column and Row combination instead.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppDimensions.borderSm,
          children: [
            for (int row = 0; row < board.rows; row++)
              Row(
                spacing: AppDimensions.borderSm,
                children: [
                  for (int col = 0; col < board.cols; col++)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _CellWidget(
                          cell: board.cell((row: row, col: col))!,
                          onTap: () => onCellTap((row: row, col: col)),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CellWidget extends StatelessWidget {
  final Cell cell;
  final VoidCallback onTap;

  const _CellWidget({required this.cell, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = cell.occupant != null
        ? context.playerColors.resolve(cell.occupant!.color)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            width: AppDimensions.borderSm,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Center(
          child: _OrbCluster(count: cell.orbCount, color: color),
        ),
      ),
    );
  }
}

class _OrbCluster extends StatelessWidget {
  final int count;
  final Color? color;

  const _OrbCluster({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    if (count == 0 || color == null) return const SizedBox.shrink();
    return Stack(
      children: [
        for (final alignment in _alignmentsFor(count))
          Align(
            alignment: alignment,
            child: Container(
              width: AppDimensions.dotSm,
              height: AppDimensions.dotSm,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color!),
            ),
          ),
      ],
    );
  }

  List<Alignment> _alignmentsFor(int count) {
    return switch (count) {
      1 => [Alignment.center],
      2 => [Alignment.centerLeft, Alignment.centerRight],
      3 => [Alignment.topCenter, Alignment.bottomLeft, Alignment.bottomRight],
      _ => [
        Alignment.topLeft,
        Alignment.topRight,
        Alignment.bottomLeft,
        Alignment.bottomRight,
      ],
    };
  }
}
