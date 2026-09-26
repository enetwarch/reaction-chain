import 'package:flutter/material.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final String? description;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.iconData,
    this.description,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppDimensions.spacingLg,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              if (iconData != null) Icon(iconData, size: AppDimensions.iconXl),
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppDimensions.spacingLg,
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
