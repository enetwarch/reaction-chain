import 'package:flutter/material.dart';
import 'package:reaction_chain/providers/local_storage_provider.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';
import 'package:reaction_chain/components/icon_button.dart';
import 'package:reaction_chain/widgets/confirmation_dialog.dart';
import 'package:reaction_chain/widgets/settings_dialog.dart';
import 'package:reaction_chain/data/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Settings settings;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final localStorage = LocalStorageProvider.of(context);
      settings = localStorage.loadSettings();
      _isInitialized = true;
    }
  }

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
                  AppIconButton(
                    iconData: Icons.play_arrow_rounded,
                    onPressed: () {
                      final savedGameState = LocalStorageProvider.of(
                        context,
                      ).loadGameState();
                      if (savedGameState == null) {
                        Navigator.pushNamed(context, '/local-lobby');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            title: 'Resume',
                            iconData: Icons.sports_esports_rounded,
                            onClose: () {
                              LocalStorageProvider.of(context).clearGameState();
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/game',
                                arguments: savedGameState,
                              );
                            },
                          ),
                        );
                      }
                    },
                    size: .xl,
                  ),
                  _ActionButtonRow(
                    onInfo: () {},
                    onSettings: () => showDialog(
                      context: context,
                      builder: (context) => SettingsDialog(
                        settings: settings,
                        onSettingsChange: () {
                          LocalStorageProvider.of(
                            context,
                          ).saveSettings(settings);
                        },
                      ),
                    ),
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

class _ActionButtonRow extends StatefulWidget {
  final VoidCallback onInfo;
  final Future<void> Function() onSettings;
  final VoidCallback onCode;

  const _ActionButtonRow({
    required this.onInfo,
    required this.onSettings,
    required this.onCode,
  });

  @override
  State<_ActionButtonRow> createState() => _ActionButtonRowState();
}

class _ActionButtonRowState extends State<_ActionButtonRow> {
  bool _isSettingsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        Flexible(
          child: AppIconButton(
            iconData: Icons.info_rounded,
            onPressed: widget.onInfo,
            size: .large,
          ),
        ),
        Flexible(
          child: AppToggleIconButton(
            iconData: Icons.settings_rounded,
            value: _isSettingsOpen,
            onChanged: (_) async {
              setState(() => _isSettingsOpen = true);
              await widget.onSettings();
              setState(() => _isSettingsOpen = false);
            },
            size: .large,
          ),
        ),
        Flexible(
          child: AppIconButton(
            iconData: Icons.code_rounded,
            onPressed: widget.onCode,
            size: .large,
          ),
        ),
      ],
    );
  }
}
