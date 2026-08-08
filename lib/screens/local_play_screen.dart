import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalPlayScreen extends StatefulWidget {
  final VoidCallback onBackButtonPress;
  final VoidCallback onPlayButtonPress;

  const LocalPlayScreen({
    super.key,
    required this.onBackButtonPress,
    required this.onPlayButtonPress,
  });

  @override
  State<LocalPlayScreen> createState() => _LocalPlayScreenState();
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

class _LocalPlayScreenState extends State<LocalPlayScreen> {
  static final ButtonStyle _buttonStyle = IconButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    backgroundColor: const Color(0xFF1A1F25),
    foregroundColor: const Color(0xFFE6E6E6),
    fixedSize: const Size(100, 100),
  );

  final List<Player> _players = [
    HumanPlayer(color: PlayerColor.red, name: 'Player 1'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1317),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 32,
              children: [
                Text(
                  'Local Play',
                  key: const Key('title'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    color: const Color(0xFFE6E6E6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 300,
                      maxWidth: 450,
                    ),
                    child: ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          // To offset the old rendered player element.
                          final player = _players.removeAt(oldIndex);
                          _players.insert(newIndex, player);
                        });
                      },
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.antiAlias,
                          child: child,
                        );
                      },
                      children: [
                        for (final (index, player) in _players.indexed)
                          Padding(
                            key: ValueKey(player),
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.antiAlias,
                              color: const Color(0xFF1A1F25),
                              child: ListTile(
                                contentPadding: .all(16),
                                leading: Icon(
                                  switch (player) {
                                    HumanPlayer() => Icons.person_rounded,
                                    BotPlayer() => Icons.computer_rounded,
                                  },
                                  size: 48,
                                  color: const Color(0xFFE6E6E6),
                                ),
                                title: Text(
                                  switch (player) {
                                    HumanPlayer(:final name) => name,
                                    BotPlayer(:final level) => 'Level $level',
                                  },
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    color: const Color(0xFFE6E6E6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(
                                    Icons.drag_handle_rounded,
                                    color: Color(0xFFE6E6E6),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    IconButton(
                      icon: Transform.rotate(
                        angle: math.pi,
                        child: const Icon(Icons.play_arrow_rounded, size: 80),
                      ),
                      onPressed: widget.onBackButtonPress,
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 80),
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
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, size: 80),
                      onPressed: widget.onPlayButtonPress,
                      style: _buttonStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
