import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/widgets/settings_dialog.dart';
import 'package:reaction_chain/data/settings.dart';

class HomeScreen extends StatelessWidget {
  final Settings settings;

  const HomeScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: .symmetric(
            horizontal: AppDimensions.spacingXxl,
            vertical: AppDimensions.spacingXxl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: AppDimensions.spacingXxl,
                children: [
                  Text(
                    'Reaction\nChain',
                    key: const Key('title'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  _PlayButton(
                    onPlay: () {
                      Navigator.pushNamed(context, '/local-lobby');
                    },
                  ),
                  _ActionButtonRow(
                    onInfo: () {},
                    onSettings: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          settings: settings,
                          onSettingsChange: () => settings.save(),
                        ),
                      );
                    },
                    onCode: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onPlay;

  const _PlayButton({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      iconData: Icons.play_arrow_rounded,
      onPressed: onPlay,
      size: .xl,
    );
  }
}

class _ActionButtonRow extends StatelessWidget {
  final VoidCallback onInfo;
  final VoidCallback onSettings;
  final VoidCallback onCode;

  const _ActionButtonRow({
    required this.onInfo,
    required this.onSettings,
    required this.onCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        Flexible(
          child: AppIconButton(
            iconData: Icons.info_rounded,
            onPressed: onInfo,
            size: .large,
          ),
        ),
        Flexible(
          child: AppIconButton(
            iconData: Icons.settings_rounded,
            onPressed: onSettings,
            size: .large,
          ),
        ),
        Flexible(
          child: AppIconButton(
            iconData: Icons.code_rounded,
            onPressed: onCode,
            size: .large,
          ),
        ),
      ],
    );
  }
}
