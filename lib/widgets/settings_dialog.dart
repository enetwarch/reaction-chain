import 'package:flutter/material.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/data/settings.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class SettingsDialog extends StatefulWidget {
  final Settings settings;
  final VoidCallback onSettingsChange;

  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onSettingsChange,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXxl,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXxl),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: AppDimensions.spacingXl),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppDimensions.spacingLg,
              children: [
                AppToggleIconButton(
                  iconData: Icons.volume_up_rounded,
                  offIconData: Icons.volume_off_rounded,
                  value: widget.settings.soundEnabled,
                  size: AppIconButtonSize.large,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.soundEnabled = value;
                    });
                    widget.onSettingsChange();
                  },
                ),
                AppToggleIconButton(
                  iconData: Icons.music_note_rounded,
                  offIconData: Icons.music_off_rounded,
                  value: widget.settings.musicEnabled,
                  size: AppIconButtonSize.large,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.musicEnabled = value;
                    });
                    widget.onSettingsChange();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppDimensions.spacingLg,
              children: [
                AppToggleIconButton(
                  iconData: Icons.touch_app_rounded,
                  offIconData: Icons.touch_app_outlined,
                  value: widget.settings.confirmationEnabled,
                  size: AppIconButtonSize.large,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.confirmationEnabled = value;
                    });
                    widget.onSettingsChange();
                  },
                ),
                AppToggleIconButton(
                  iconData: Icons.vibration_rounded,
                  offIconData: Icons.mobile_off_rounded,
                  value: widget.settings.vibrationEnabled,
                  size: AppIconButtonSize.large,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.vibrationEnabled = value;
                    });
                    widget.onSettingsChange();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
