import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/widgets/player_card_dialog.dart';

class LocalLobbyScreen extends StatefulWidget {
  const LocalLobbyScreen({super.key});

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

class _LocalLobbyScreenState extends State<LocalLobbyScreen> {
  final List<Player> _players = [
    HumanPlayer(color: PlayerColor.red, name: 'Player 1'),
  ];

  void _reorderPlayer(int oldIndex, int newIndex) {
    setState(() {
      // To offset the old rendered player element.
      if (newIndex > oldIndex) newIndex -= 1;

      final player = _players.removeAt(oldIndex);
      _players.insert(newIndex, player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: AppDimensions.spacingLg,
              left: AppDimensions.spacingLg,
              child: IconButton(
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
                onPressed: () {
                  Navigator.pop(context);
                },
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXxl,
                vertical: AppDimensions.spacingXxxl,
              ),
              child: Center(
                child: Column(
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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 300,
                          maxWidth: 420,
                        ),
                        child: ReorderableListView(
                          onReorder: _reorderPlayer,
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
                            for (final (index, player) in _players.indexed)
                              Padding(
                                key: ValueKey(player),
                                padding: EdgeInsets.only(
                                  bottom: AppDimensions.spacingMd,
                                ),
                                child: _playerListTile(context, index, player),
                              ),
                          ],
                        ),
                      ),
                    ),
                    _actionButtonRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerListTile(BuildContext context, int index, Player player) {
    return Material(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF1A1F25),
      child: ListTile(
        contentPadding: .all(AppDimensions.spacingLg),
        leading: Icon(switch (player) {
          HumanPlayer() => Icons.person_rounded,
          BotPlayer() => Icons.computer_rounded,
        }, size: AppDimensions.iconMd),
        title: Text(switch (player) {
          HumanPlayer(:final name) => name,
          BotPlayer(:final level) => 'Level $level',
        }, style: Theme.of(context).textTheme.displayMedium),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Icon(
            Icons.drag_handle_rounded,
            size: AppDimensions.iconSm,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => PlayerCardDialog(
              player: player,
              onDelete: () {
                setState(() {
                  _players.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _actionButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        IconButton(
          icon: const Icon(Icons.person_rounded, size: AppDimensions.iconLg),
          onPressed: () {
            if (_players.length >= 4) return;
            setState(() {
              _players.add(
                HumanPlayer(
                  color: PlayerColor.blue,
                  name: 'Player ${_players.length + 1}',
                ),
              );
            });
          },
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.play_arrow_rounded,
            size: AppDimensions.iconLg,
          ),
          onPressed: () {},
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.smart_toy_rounded, size: AppDimensions.iconLg),
          onPressed: () {},
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
      ],
    );
  }
}
