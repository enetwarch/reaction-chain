import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class LocalLobbyScreen extends StatefulWidget {
  final VoidCallback onBackButtonPress;
  final VoidCallback onPlayButtonPress;

  const LocalLobbyScreen({
    super.key,
    required this.onBackButtonPress,
    required this.onPlayButtonPress,
  });

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

enum PlayerColor { red, green, blue, yellow }

// The sealed keyword makes it unextendable on other files.
sealed class Player {
  final PlayerColor color;

  Player({required this.color});
}

class HumanPlayer extends Player {
  final String name;

  HumanPlayer({required super.color, required this.name});
}

class BotPlayer extends Player {
  final int level;

  BotPlayer({required super.color, required this.level});
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
                onPressed: widget.onBackButtonPress,
                style: Theme.of(context).iconButtonTheme.style?.copyWith(
                  fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXl,
                vertical: AppDimensions.spacingXxl,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: AppDimensions.spacingXl,
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
                          maxWidth: 450,
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
        onTap: () {},
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
          onPressed: widget.onPlayButtonPress,
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
