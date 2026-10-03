import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final void Function(Coordinates) onCellTap;
  final Map<Coordinates, CellHighlight> highlights;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onCellTap,
    this.highlights = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
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
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppDimensions.borderSm,
                  children: [
                    for (int col = 0; col < board.cols; col++)
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppDimensions.cell,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _CellWidget(
                              cell: board.cell((row: row, col: col))!,
                              highlight: highlights[(row: row, col: col)],
                              onTap: () => onCellTap((row: row, col: col)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CellWidget extends StatefulWidget {
  final Cell cell;
  final CellHighlight? highlight;
  final VoidCallback onTap;

  const _CellWidget({
    required this.cell,
    required this.highlight,
    required this.onTap,
  });

  @override
  State<_CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<_CellWidget>
    with TickerProviderStateMixin {
  static const _blinkPeriod = Duration(milliseconds: 1000);
  static const _armIn = Duration(milliseconds: 250);
  static const _armOut = Duration(milliseconds: 400);
  static const _blinkOut = Duration(milliseconds: 300);

  late final AnimationController _blink;
  late final AnimationController _arm;
  late final Listenable _both;

  Color Function(BuildContext)? _blinkColorOf;
  Color Function(BuildContext)? _armColorOf;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(vsync: this, duration: _blinkPeriod);
    _arm = AnimationController(vsync: this, duration: _armIn);
    _both = Listenable.merge([_blink, _arm]);
    _captureColors();
    _applyMode();
  }

  @override
  void didUpdateWidget(covariant _CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _captureColors();
    if (oldWidget.highlight?.mode != widget.highlight?.mode) _applyMode();
  }

  void _captureColors() {
    if (widget.highlight == null) return;
    switch (widget.highlight!.mode) {
      case CellHighlightMode.blink:
        _blinkColorOf = widget.highlight!.colorOf;
      case CellHighlightMode.armed:
        _armColorOf = widget.highlight!.colorOf;
    }
  }

  void _applyMode() {
    switch (widget.highlight?.mode) {
      case null:
        _blink.animateTo(0, duration: _blinkOut);
        _arm.animateTo(0, duration: _armOut);
      case CellHighlightMode.armed:
        _blink.animateTo(0, duration: _blinkOut);
        _arm.animateTo(1, duration: _armIn);
      case CellHighlightMode.blink:
        _arm.animateTo(0, duration: _armOut);
        _blink.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blink.dispose();
    _arm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orbColor = widget.cell.occupant != null
        ? widget.cell.occupant!.isOut
              ? Theme.of(context).colorScheme.onSurface
              : context.playerColors.resolve(widget.cell.occupant!.color)
        : null;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _both,
        builder: (context, child) {
          final base = Theme.of(context).colorScheme.surfaceContainerLowest;
          final blinkT = Curves.easeInOut.transform(_blink.value);
          final armT = Curves.easeInOut.transform(_arm.value);

          final blinkColor = Color.lerp(
            base,
            _blinkColorOf?.call(context) ?? base,
            blinkT,
          );

          final color = Color.lerp(
            blinkColor,
            _armColorOf?.call(context) ?? base,
            armT,
          );

          return Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                width: AppDimensions.borderSm,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: _OrbCluster(count: widget.cell.orbCount, color: orbColor),
        ),
      ),
    );
  }
}

class _OrbCluster extends StatelessWidget {
  final int count;
  final Color? color;
  final Duration duration;

  const _OrbCluster({
    required this.count,
    required this.color,
    // ignore: unused_element_parameter
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 || color == null) return const SizedBox.shrink();
    return Stack(
      children: [
        for (final (i, alignment) in _alignmentsFor(count).indexed)
          AnimatedAlign(
            key: ValueKey(i),
            alignment: alignment,
            duration: duration,
            curve: Curves.easeOutBack,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: duration,
              curve: Curves.easeOutBack,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                width: AppDimensions.dotSm,
                height: AppDimensions.dotSm,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color!,
                ),
              ),
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
