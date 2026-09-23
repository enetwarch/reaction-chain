// lib/components/icon_button.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

enum AppIconButtonSize { small, large, xl }

class AppIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final AppIconButtonSize size;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.size = AppIconButtonSize.small,
    this.backgroundColor,
    this.iconColor,
  });

  static const double _iconToButtonRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (size == AppIconButtonSize.small) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(iconData, size: AppDimensions.iconSm, color: iconColor),
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
          icon: Icon(iconData, size: iconSize, color: iconColor),
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

// This icon button highlights itself first and then when pressed again,
// it will finally do its intended onPress function (onConfirm).
class AppArmedIconButton extends StatefulWidget {
  final IconData iconData;
  final VoidCallback? onArm;
  final VoidCallback onConfirm;
  final AppIconButtonSize size;
  final Duration? armDuration;
  final Duration transitionDuration;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppArmedIconButton({
    super.key,
    required this.iconData,
    required this.onConfirm,
    this.onArm,
    this.size = AppIconButtonSize.small,
    this.armDuration = const Duration(seconds: 5),
    this.transitionDuration = const Duration(milliseconds: 200),
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<AppArmedIconButton> createState() => _AppArmedIconButtonState();
}

class _AppArmedIconButtonState extends State<AppArmedIconButton> {
  bool _isArmed = false;
  Timer? _armTimer;

  @override
  void dispose() {
    _armTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    if (_isArmed) {
      _armTimer?.cancel();
      setState(() => _isArmed = false);
      widget.onConfirm();
      return;
    }

    widget.onArm?.call();
    setState(() => _isArmed = true);

    if (widget.armDuration != null) {
      _armTimer = Timer(widget.armDuration!, () {
        if (mounted) setState(() => _isArmed = false);
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final background =
        widget.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerLow;
    final foreground =
        widget.iconColor ?? Theme.of(context).colorScheme.onSurface;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _isArmed ? 1.0 : 0.0),
      duration: widget.transitionDuration,
      builder: (context, t, child) {
        return AppIconButton(
          iconData: widget.iconData,
          onPressed: _onTap,
          size: widget.size,
          backgroundColor: Color.lerp(background, foreground, t),
          iconColor: Color.lerp(foreground, background, t),
        );
      },
    );
  }
}
