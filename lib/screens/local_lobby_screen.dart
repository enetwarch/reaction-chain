import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:reaction_chain/controllers/player_list_controller.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/screens/game_screen.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';
import 'package:reaction_chain/widgets/player_card_dialog.dart';

class LocalLobbyScreen extends StatefulWidget {
  const LocalLobbyScreen({super.key});

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

class _LocalLobbyScreenState extends State<LocalLobbyScreen> {
  final PlayerListController playerListController = PlayerListController();

  void managePlayer(int index) {
    if (playerListController.playerCount <= index) return;

    showDialog(
      context: context,
      builder: (context) => ListenableBuilder(
        listenable: playerListController,
        builder: (context, _) => PlayerCardDialog(
          player: playerListController.players[index],
          onDelete: () {
            playerListController.removePlayer(index);
            Navigator.of(context).pop();
          },
          onClose: () => Navigator.of(context).pop(),
          onColorChange: (color) =>
              playerListController.changePlayerColor(index, color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerListController,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXxl,
                vertical: AppDimensions.spacingXxxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxWidth,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: AppDimensions.spacingLg,
                        left: AppDimensions.spacingLg,
                        child: _BackButton(
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: AppDimensions.spacingXxl,
                        children: [
                          Text(
                            'Local\nLobby',
                            key: const Key('title'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Expanded(
                            child: ReorderableListView(
                              onReorder: playerListController.reorderPlayer,
                              proxyDecorator: (child, index, animation) {
                                return Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSm,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: child,
                                );
                              },
                              children: [
                                for (final (index, player)
                                    in playerListController.players.indexed)
                                  Padding(
                                    key: ValueKey(player),
                                    padding: EdgeInsets.only(
                                      bottom: AppDimensions.spacingMd,
                                    ),
                                    child: _PlayerListTile(
                                      player: player,
                                      index: index,
                                      onTap: () => managePlayer(index),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          _ActionButtonRow(
                            onPerson: () {
                              playerListController.addPlayer(PlayerType.human);
                            },
                            onPlay: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    players: playerListController.players,
                                  ),
                                ),
                              );
                            },
                            onBot: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Transform.translate(
        // Rotate will off-center the icon, this will center it back.
        offset: const Offset(2, 1),
        child: Transform.rotate(
          angle: math.pi,
          child: const Icon(
            Icons.play_arrow_rounded,
            size: AppDimensions.iconSm,
          ),
        ),
      ),
      onPressed: onPressed,
      style: Theme.of(context).iconButtonTheme.style?.copyWith(
        fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
      ),
    );
  }
}

class _PlayerListTile extends StatelessWidget {
  final Player player;
  final int index;
  final VoidCallback onTap;

  const _PlayerListTile({
    required this.player,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF1A1F25),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppDimensions.spacingLg),
        leading: Icon(
          player.displayIcon,
          size: AppDimensions.iconMd,
          color: context.playerColors.resolve(player.color),
        ),
        title: Text(
          player.displayName,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Icon(
            Icons.drag_handle_rounded,
            size: AppDimensions.iconSm,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ActionButtonRow extends StatelessWidget {
  final VoidCallback onPerson;
  final VoidCallback onPlay;
  final VoidCallback onBot;

  const _ActionButtonRow({
    required this.onPerson,
    required this.onPlay,
    required this.onBot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        IconButton(
          icon: const Icon(Icons.person_rounded, size: AppDimensions.iconLg),
          onPressed: onPerson,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.play_arrow_rounded,
            size: AppDimensions.iconLg,
          ),
          onPressed: onPlay,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.smart_toy_rounded, size: AppDimensions.iconLg),
          onPressed: onBot,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
      ],
    );
  }
}
