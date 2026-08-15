import 'package:flutter/material.dart';
import 'package:reaction_chain/controllers/game_controller.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;

  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController gameController;

  @override
  void initState() {
    super.initState();
    gameController = GameController(players: widget.players);
  }

  void onCellTap(Coordinates coordinates) async {
    final events = gameController.placeOrb(coordinates);
    for (final event in events) {
      await _animateExplosion(event);
    }
    gameController.refresh();
  }

  Future<void> _animateExplosion(ExplosionEvent event) async {
    gameController.refresh();
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: gameController,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(AppDimensions.spacingXxl),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: AppDimensions.spacingMd,
                      children: [
                        _TopMenuBar(turnPlayer: gameController.currentPlayer),
                        _PlayerScores(players: gameController.players),
                      ],
                    ),
                    _BoardWidget(
                      gameController: gameController,
                      onCellTap: onCellTap,
                    ),
                    _BottomMenuBar(turnNumber: gameController.turnNumber),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopMenuBar extends StatelessWidget {
  final Player turnPlayer;

  const _TopMenuBar({required this.turnPlayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      padding: EdgeInsets.all(AppDimensions.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
            child: Row(
              spacing: AppDimensions.spacingMd,
              children: [
                Icon(
                  turnPlayer.displayIcon,
                  size: AppDimensions.iconSm,
                  color: context.playerColors.resolve(turnPlayer.color),
                ),
                Text(
                  turnPlayer.displayName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          Row(
            spacing: AppDimensions.spacingMd,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home_rounded,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () {},
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_rounded,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () {},
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerScores extends StatelessWidget {
  final List<Player> players;

  const _PlayerScores({required this.players});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimensions.spacingMd,
      children: [
        for (final player in players) ...[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.spacingMd,
              horizontal: AppDimensions.spacingLg,
            ),
            child: Row(
              spacing: AppDimensions.spacingMd,
              children: [
                Icon(
                  Icons.circle,
                  size: AppDimensions.dotSm,
                  color: context.playerColors.resolve(player.color),
                ),
                Text(
                  player.orbCount.toString(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BoardWidget extends StatelessWidget {
  final GameController gameController;
  final void Function(Coordinates) onCellTap;

  const _BoardWidget({required this.gameController, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    final board = gameController.board;
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

class _BottomMenuBar extends StatelessWidget {
  final int turnNumber;

  const _BottomMenuBar({required this.turnNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
            child: Text(
              'Turn ${turnNumber.toString()}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Row(
            spacing: AppDimensions.spacingMd,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.flag_rounded,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () {},
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.undo_rounded,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () {},
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.pause_rounded,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () {},
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
