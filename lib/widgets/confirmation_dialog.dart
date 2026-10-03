import 'package:flutter/material.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final Color? iconColor;
  final String? description;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.iconData,
    this.iconColor,
    this.description,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppOverlayWidth.md,
          maxWidth: AppOverlayWidth.lg,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.lg,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              if (iconData != null)
                Icon(iconData, size: AppIconSizing.xl, color: iconColor),
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppSpacing.lg,
                children: [
                  AppIconButton(
                    iconData: Icons.close_rounded,
                    onPressed: onClose,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerLow,
                    size: .large,
                  ),
                  AppIconButton(
                    iconData: Icons.check_rounded,
                    onPressed: onConfirm,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerLow,
                    size: .large,
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
