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
    return SizedBox(
      width: AppDimensions.cell * board.cols + AppDimensions.borderSm * 2,
      height: AppDimensions.cell * board.rows + AppDimensions.borderSm * 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              width: AppDimensions.borderSm,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.cols,
              childAspectRatio: 1,
              crossAxisSpacing: AppDimensions.borderSm,
              mainAxisSpacing: AppDimensions.borderSm,
            ),
            itemCount: board.rows * board.cols,
            itemBuilder: (context, index) {
              final coordinates = (
                row: index ~/ board.cols,
                col: index % board.cols,
              );
              return _CellWidget(
                cell: board.cell(coordinates)!,
                onTap: () => onCellTap(coordinates),
              );
            },
          ),
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
