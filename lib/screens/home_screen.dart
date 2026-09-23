import 'package:flutter/material.dart';
import 'package:reaction_chain/screens/local_lobby_screen.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/components/icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: .symmetric(
            horizontal: AppDimensions.spacingXxl,
            vertical: AppDimensions.spacingXxxl,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocalLobbyScreen(),
                        ),
                      );
                    },
                  ),
                  _ActionButtonRow(
                    onInfo: () {},
                    onSettings: () {},
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
        AppIconButton(
          iconData: Icons.info_rounded,
          onPressed: () {},
          size: .large,
        ),
        AppIconButton(
          iconData: Icons.settings_rounded,
          onPressed: () {},
          size: .large,
        ),
        AppIconButton(
          iconData: Icons.code_rounded,
          onPressed: () {},
          size: .large,
        ),
      ],
    );
  }
}
