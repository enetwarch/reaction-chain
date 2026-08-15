import 'package:flutter/material.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';

class PlayerCardDialog extends StatelessWidget {
  final Player player;
  final VoidCallback onDelete;
  final VoidCallback onClose;
  final void Function(PlayerColor) onColorChange;

  const PlayerCardDialog({
    super.key,
    required this.player,
    required this.onDelete,
    required this.onClose,
    required this.onColorChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXxl,
      ),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Stack(
          children: [
            Positioned(
              top: AppDimensions.spacingLg,
              left: AppDimensions.spacingLg,
              child: _SmallIconButton(
                iconData: Icons.delete_rounded,
                onPressed: onDelete,
              ),
            ),
            Positioned(
              top: AppDimensions.spacingLg,
              right: AppDimensions.spacingLg,
              child: _SmallIconButton(
                iconData: Icons.close_rounded,
                onPressed: onClose,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXl,
                vertical: AppDimensions.spacingXxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (player) {
                    HumanPlayer() => Icon(
                      Icons.person_rounded,
                      size: AppDimensions.iconLg,
                      color: theme.colorScheme.onSurface,
                    ),
                    BotPlayer() => Icon(
                      Icons.smart_toy_rounded,
                      size: AppDimensions.iconLg,
                      color: theme.colorScheme.onSurface,
                    ),
                  },
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(switch (player) {
                    HumanPlayer(name: final name) => name,
                    BotPlayer(level: final level) => 'Level $level',
                  }, style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: AppDimensions.spacingXl),
                  _ActionButtonRow(player: player),
                  const SizedBox(height: AppDimensions.spacingXl),
                  _ColorPicker(player: player, onColorChange: onColorChange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const _SmallIconButton({required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData, size: AppDimensions.iconSm),
      style: Theme.of(context).iconButtonTheme.style?.copyWith(
        fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }
}

class _ActionButtonRow extends StatelessWidget {
  final Player player;

  const _ActionButtonRow({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingMd,
      children: switch (player) {
        HumanPlayer() => [
          _SmallIconButton(onPressed: () {}, iconData: Icons.edit_rounded),
          _SmallIconButton(onPressed: () {}, iconData: Icons.shuffle_rounded),
          _SmallIconButton(onPressed: () {}, iconData: Icons.refresh_rounded),
        ],
        BotPlayer() => [
          _SmallIconButton(
            onPressed: () {},
            iconData: Icons.arrow_upward_rounded,
          ),
          _SmallIconButton(onPressed: () {}, iconData: Icons.shuffle_rounded),
          _SmallIconButton(
            onPressed: () {},
            iconData: Icons.arrow_downward_rounded,
          ),
        ],
      },
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final Player player;
  final void Function(PlayerColor) onColorChange;

  const _ColorPicker({required this.player, required this.onColorChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        for (final color in PlayerColor.values) ...[
          _ColorDot(
            color: context.playerColors.resolve(color),
            isSelected: player.color == color,
            onTap: () => onColorChange(color),
          ),
        ],
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.dotMd,
        height: AppDimensions.dotMd,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: (isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: AppDimensions.borderSm,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : Border.all(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  width: AppDimensions.borderSm,
                )),
        ),
      ),
    );
  }
}
