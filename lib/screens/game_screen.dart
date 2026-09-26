import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reaction_chain/controllers/game_controller.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/game_state.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/data/settings.dart';
import 'package:reaction_chain/providers/local_storage_provider.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/widgets/board_widget.dart';
import 'package:reaction_chain/widgets/settings_dialog.dart';

class GameScreen extends StatefulWidget {
  final List<Player>? players;
  final GameState? savedState;

  const GameScreen({super.key, this.players, this.savedState})
    : assert(
        players != null || savedState != null,
        'Provide either players (new game) or savedState (resume).',
      );

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController gameController;
  late final Settings settings;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final localStorage = LocalStorageProvider.of(context);
      settings = localStorage.loadSettings();
      gameController = widget.savedState != null
          ? GameController.fromState(
              widget.savedState!,
              localStorage: localStorage,
            )
          : GameController(
              players: widget.players!,
              localStorage: localStorage,
            );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    gameController.dispose();
    super.dispose();
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
                                  onHome: () => Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst),
                                  onSettings: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SettingsDialog(
                                        settings: settings,
                                        onSettingsChange: () =>
                                            LocalStorageProvider.of(
                                              context,
                                            ).saveSettings(settings),
                                      ),
                                    );
                                  },
                                ),
                                _PlayerScores(
                                  players: gameController.players,
                                  currentPlayer: gameController.currentPlayer,
                                ),
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
        spacing: AppDimensions.spacingMd,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
              child: Row(
                spacing: AppDimensions.spacingMd,
                children: [
                  Icon(
                    turnPlayer.displayIcon,
                    size: AppDimensions.iconSm,
                    color: context.playerColors.resolve(turnPlayer.color),
                  ),
                  Expanded(
                    child: Text(
                      turnPlayer.displayName,
                      style: Theme.of(context).textTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
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

class _PlayerScores extends StatefulWidget {
  final Player currentPlayer;
  final List<Player> players;

  const _PlayerScores({required this.currentPlayer, required this.players});

  @override
  State<_PlayerScores> createState() => _PlayerScoresState();
}

class _PlayerScoresState extends State<_PlayerScores> {
  final _scrollController = ScrollController();
  late final Map<PlayerColor, GlobalKey> _cardKeys;

  @override
  void initState() {
    super.initState();
    _cardKeys = {
      for (final player in widget.players) player.color: GlobalKey(),
    };
  }

  @override
  void didUpdateWidget(_PlayerScores oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPlayer.color != widget.currentPlayer.color) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToCurrentPlayer(),
      );
    }
  }

  void _scrollToCurrentPlayer() {
    final key = _cardKeys[widget.currentPlayer.color];
    final context = key?.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.5,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _scrollController.jumpTo(
            (_scrollController.offset + event.scrollDelta.dy).clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: AppDimensions.spacingMd,
          children: [
            for (final player in widget.players) ...[
              Container(
                key: _cardKeys[player.color],
                child: _PlayerScoreCard(
                  player: player,
                  isActive: player.color == widget.currentPlayer.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerScoreCard extends StatelessWidget {
  final Player player;
  final bool isActive;

  const _PlayerScoreCard({required this.player, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.surfaceContainerLowest;
    final foreground = theme.colorScheme.onSurface;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isActive ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      builder: (context, t, child) {
        final currentBg = Color.lerp(background, foreground, t);
        final currentFg = Color.lerp(foreground, background, t);

        return Container(
          decoration: BoxDecoration(
            color: currentBg,
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
                style: theme.textTheme.displayMedium?.copyWith(
                  color: currentFg,
                ),
              ),
            ],
          ),
        );
      },
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
