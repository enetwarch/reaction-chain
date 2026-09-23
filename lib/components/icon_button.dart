// lib/components/icon_button.dart
import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

enum AppIconButtonSize { small, large, xl }

class AppIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final AppIconButtonSize size;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.size = AppIconButtonSize.small,
    this.backgroundColor,
  });

  static const double _iconToButtonRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (size == AppIconButtonSize.small) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(iconData, size: AppDimensions.iconSm),
        style: theme.iconButtonTheme.style?.copyWith(
          fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonSm),
          backgroundColor: backgroundColor != null
              ? WidgetStatePropertyAll(backgroundColor)
              : null,
        ),
      );
    }

    final (minSize, maxSize, radius) = switch (size) {
      AppIconButtonSize.large => (
        AppDimensions.iconButtonLgMin,
        AppDimensions.iconButtonLg,
        null,
      ),
      AppIconButtonSize.xl => (
        AppDimensions.iconButtonXlMin,
        AppDimensions.iconButtonXl,
        AppDimensions.radiusMd,
      ),
      AppIconButtonSize.small => throw StateError('handled above'),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth.clamp(minSize.width, maxSize.width);
        final iconSize = side * _iconToButtonRatio;

        return IconButton(
          onPressed: onPressed,
          icon: Icon(iconData, size: iconSize),
          style: theme.iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(Size(side, side)),
            backgroundColor: backgroundColor != null
                ? WidgetStatePropertyAll(backgroundColor)
                : null,
            shape: WidgetStatePropertyAll(
              radius != null
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
