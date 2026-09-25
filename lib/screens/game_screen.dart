import 'package:flutter/material.dart';
import 'package:reaction_chain/controllers/game_controller.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/data/settings.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/widgets/board_widget.dart';
import 'package:reaction_chain/widgets/settings_dialog.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final Settings settings;

  const GameScreen({super.key, required this.players, required this.settings});

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppDimensions.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.spacingXxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Section
                            Column(
                              spacing: AppDimensions.spacingMd,
                              children: [
                                _TopMenuBar(
                                  turnPlayer: gameController.currentPlayer,
                                  onHome: () {},
                                  onSettings: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SettingsDialog(
                                        settings: widget.settings,
                                        onSettingsChange: () =>
                                            widget.settings.save(),
                                      ),
                                    );
                                  },
                                ),
                                _PlayerScores(players: gameController.players),
                              ],
                            ),

                            // Middle Board
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.spacingLg,
                              ),
                              child: BoardWidget(
                                board: gameController.board,
                                onCellTap: onCellTap,
                              ),
                            ),

                            // Bottom Section
                            _BottomMenuBar(
                              turnNumber: gameController.turnNumber,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _TopMenuBar extends StatelessWidget {
  final Player turnPlayer;
  final VoidCallback onHome;
  final VoidCallback onSettings;

  const _TopMenuBar({
    required this.turnPlayer,
    required this.onHome,
    required this.onSettings,
  });

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
              AppIconButton(
                iconData: Icons.home_rounded,
                onPressed: onHome,
                size: .small,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
              ),
              AppIconButton(
                iconData: Icons.settings_rounded,
                onPressed: onSettings,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
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
              AppIconButton(
                iconData: Icons.flag_rounded,
                onPressed: () {},
                size: .small,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
              ),
              AppIconButton(
                iconData: Icons.undo_rounded,
                onPressed: () {},
                size: .small,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
              ),
              AppIconButton(
                iconData: Icons.pause_rounded,
                onPressed: () {},
                size: .small,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
