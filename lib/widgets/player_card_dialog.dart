import 'package:flutter/material.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/theme/player_colors.dart';
import 'package:reaction_chain/components/icon_button.dart';

class PlayerCardDialog extends StatelessWidget {
  final Player player;
  final VoidCallback onDelete;
  final VoidCallback onClose;
  final void Function(PlayerColor) onColorChange;
  final void Function(String) onNameChange;

  const PlayerCardDialog({
    super.key,
    required this.player,
    required this.onDelete,
    required this.onClose,
    required this.onColorChange,
    required this.onNameChange,
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 300),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Stack(
            children: [
              Positioned(
                top: AppDimensions.spacingLg,
                left: AppDimensions.spacingLg,
                child: AppArmedIconButton(
                  iconData: Icons.delete_rounded,
                  onConfirm: onDelete,
                  size: .small,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow,
                ),
              ),
              Positioned(
                top: AppDimensions.spacingLg,
                right: AppDimensions.spacingLg,
                child: AppIconButton(
                  iconData: Icons.close_rounded,
                  onPressed: onClose,
                  size: .small,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow,
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
                    Icon(
                      player.displayIcon,
                      size: AppDimensions.iconLg,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Text(switch (player) {
                      HumanPlayer(name: final name) => name,
                      BotPlayer(level: final level) => 'Level $level',
                    }, style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: AppDimensions.spacingXl),
                    switch (player) {
                      HumanPlayer() => _NameRow(
                        name: player.displayName,
                        onNameChange: onNameChange,
                      ),
                      BotPlayer() => SizedBox(), // Placeholder, not in MVP.
                    },
                    const SizedBox(height: AppDimensions.spacingMd),
                    _ColorEditRow(
                      selectedColor: player.color,
                      onColorChange: onColorChange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameRow extends StatefulWidget {
  final String name;
  final void Function(String) onNameChange;

  const _NameRow({required this.name, required this.onNameChange});

  @override
  State<_NameRow> createState() => _NameRowState();
}

class _NameRowState extends State<_NameRow> {
  late final TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final trimmed = _controller.text.trim();
    if (trimmed.isNotEmpty) {
      widget.onNameChange(trimmed);
    } else {
      _controller.text = widget.name; // revert if left blank
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppDimensions.iconButtonSm.height,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            alignment: Alignment.centerLeft,
            child: _isEditing
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    style: theme.textTheme.displayMedium,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _submit(),
                  )
                : Text(
                    widget.name,
                    style: theme.textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        AppArmedIconButton(
          iconData: _isEditing ? Icons.check_rounded : Icons.edit_rounded,
          onArm: () => setState(() => _isEditing = true),
          onConfirm: () => _submit(),
          armDuration: null,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          // iconColor is default (foreground)
        ),
      ],
    );
  }
}

class _ColorEditRow extends StatelessWidget {
  final PlayerColor selectedColor;
  final void Function(PlayerColor) onColorChange;

  const _ColorEditRow({
    required this.selectedColor,
    required this.onColorChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Theme(
          data: theme.copyWith(
            iconButtonTheme: IconButtonThemeData(
              style: theme.iconButtonTheme.style?.copyWith(
                backgroundColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
              ),
            ),
          ),
          child: Expanded(
            child: DropdownMenu<PlayerColor>(
              expandedInsets: EdgeInsets.zero,
              initialSelection: selectedColor,
              onSelected: (color) {
                if (color != null) onColorChange(color);
              },
              textStyle: theme.textTheme.displayMedium,
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(
                  theme
                      .colorScheme
                      .surfaceContainerLow, // matches your defined "subsurface" tier
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: BorderSide.none,
                ),
              ),
              trailingIcon: Icon(
                Icons.expand_more_rounded,
                size: AppDimensions.iconSm,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              selectedTrailingIcon: Icon(
                Icons.expand_less_rounded,
                size: AppDimensions.iconSm,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              dropdownMenuEntries: [
                for (final color in PlayerColor.values)
                  DropdownMenuEntry(
                    value: color,
                    label: color.label,
                    style: MenuItemButton.styleFrom(
                      textStyle: theme.textTheme.displaySmall,
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    leadingIcon: Container(
                      width: AppDimensions.dotSm,
                      height: AppDimensions.dotSm,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.playerColors.resolve(color),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        AppIconButton(
          iconData: Icons.shuffle_rounded,
          onPressed: () =>
              onColorChange(PlayerColor.random(exclude: selectedColor)),
          size: .small,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ],
    );
  }
}
