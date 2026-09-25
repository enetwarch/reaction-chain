import 'package:flutter/material.dart';
import 'package:reaction_chain/controllers/player_list_controller.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';
import 'package:reaction_chain/widgets/player_card_dialog.dart';
import 'package:reaction_chain/components/icon_button.dart';

class LocalLobbyScreen extends StatefulWidget {
  const LocalLobbyScreen({super.key});

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

class _LocalLobbyScreenState extends State<LocalLobbyScreen> {
  final PlayerListController playerListController = PlayerListController();
  bool _isDialOpen = false;

  void managePlayer(int index) {
    if (playerListController.playerCount <= index) return;

    showDialog(
      context: context,
      builder: (context) => ListenableBuilder(
        listenable: playerListController,
        builder: (context, _) {
          if (index >= playerListController.players.length) {
            return const SizedBox.shrink();
          }
          return PlayerCardDialog(
            player: playerListController.players[index],
            onDelete: () {
              Navigator.of(context).pop();
              playerListController.removePlayer(index);
            },
            onClose: () => Navigator.of(context).pop(),
            onColorChange: (newColor) =>
                playerListController.changePlayerColor(index, newColor),
            onNameChange: (newName) =>
                playerListController.changePlayerName(index, newName),
          );
        },
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
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingXxl,
                    vertical: AppDimensions.spacingXxl,
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
                            child: AppIconButton(
                              iconData: Icons.arrow_back_rounded,
                              onPressed: () => Navigator.pop(context),
                              size: .small,
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
                                child: _PlayerList(
                                  players: playerListController.players,
                                  onReorder: playerListController.reorderPlayer,
                                  onListTileTap: (index) => managePlayer(index),
                                ),
                              ),
                              AppIconButton(
                                iconData: Icons.play_arrow_rounded,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/game',
                                    arguments: playerListController.players,
                                  );
                                },
                                size: .large,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: !_isDialOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isDialOpen ? 1 : 0,
                    child: GestureDetector(
                      onTap: () => setState(() => _isDialOpen = false),
                      child: Container(
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.spacingLg,
                  right: AppDimensions.spacingLg,
                  child: SpeedDialMenu(
                    onAddHuman: () {
                      playerListController.addPlayer(PlayerType.human);
                    },
                    onAddBot: () {}, // Not fully polished yet, so left empty.
                    onToggle: (isOpen) => setState(() => _isDialOpen = isOpen),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<Player> players;
  final Function(int, int) onReorder;
  final Function(int) onListTileTap;

  const _PlayerList({
    required this.players,
    required this.onReorder,
    required this.onListTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      children: [
        for (final (index, player) in players.indexed)
          Padding(
            key: ValueKey(player),
            padding: EdgeInsets.only(bottom: AppDimensions.spacingMd),
            child: _PlayerListTile(
              player: player,
              index: index,
              onTap: () => onListTileTap(index),
            ),
          ),
      ],
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
            Icons.drag_indicator_rounded,
            size: AppDimensions.iconSm,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class SpeedDialMenu extends StatefulWidget {
  final VoidCallback onAddHuman;
  final VoidCallback onAddBot;
  final ValueChanged<bool>? onToggle;

  const SpeedDialMenu({
    super.key,
    required this.onAddHuman,
    required this.onAddBot,
    this.onToggle,
  });

  @override
  State<SpeedDialMenu> createState() => _SpeedDialMenuState();
}

class _SpeedDialMenuState extends State<SpeedDialMenu> {
  bool _isOpen = false;

  void _toggleMenu() {
    setState(() => _isOpen = !_isOpen);
    widget.onToggle?.call(_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppDimensions.spacingMd,
      children: [
        _SpeedDialItem(
          index: 0,
          isOpen: _isOpen,
          iconData: Icons.smart_toy_rounded,
          onPressed: () {
            _toggleMenu();
            widget.onAddBot();
          },
        ),
        _SpeedDialItem(
          index: 1,
          isOpen: _isOpen,
          iconData: Icons.person_rounded,
          onPressed: () {
            _toggleMenu();
            widget.onAddHuman();
          },
        ),
        AppIconButton(
          iconData: _isOpen ? Icons.close_rounded : Icons.add_rounded,
          onPressed: _toggleMenu,
          size: AppIconButtonSize.large,
        ),
      ],
    );
  }
}

class _SpeedDialItem extends StatelessWidget {
  final int index;
  final bool isOpen;
  final IconData iconData;
  final VoidCallback onPressed;

  const _SpeedDialItem({
    required this.index,
    required this.isOpen,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 200 + index * 50),
      curve: Curves.easeOut,
      offset: isOpen ? Offset.zero : const Offset(0, 0.3),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200 + index * 50),
        opacity: isOpen ? 1 : 0,
        child: IgnorePointer(
          ignoring: !isOpen,
          child: AppIconButton(
            iconData: iconData,
            onPressed: onPressed,
            size: .large,
          ),
        ),
      ),
    );
  }
}
