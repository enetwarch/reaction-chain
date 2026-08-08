import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onPlayButtonPress;
  final VoidCallback onInfoButtonPress;
  final VoidCallback onSettingsButtonPress;
  final VoidCallback onCodeButtonPress;

  const HomeScreen({
    super.key,
    required this.onPlayButtonPress,
    required this.onInfoButtonPress,
    required this.onSettingsButtonPress,
    required this.onCodeButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: .symmetric(
            horizontal: AppDimensions.spacingXl,
            vertical: AppDimensions.spacingXxl,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppDimensions.spacingXl,
              children: [
                Text(
                  'Reaction\nChain',
                  key: const Key('title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    size: AppDimensions.iconXl,
                  ),
                  onPressed: onPlayButtonPress,
                  style: Theme.of(context).iconButtonTheme.style?.copyWith(
                    fixedSize: WidgetStatePropertyAll(
                      AppDimensions.iconButtonXl,
                    ),
                  ),
                ),
                _buttonRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppDimensions.spacingLg,
      children: [
        IconButton(
          icon: Icon(Icons.info_rounded, size: AppDimensions.iconLg),
          onPressed: onInfoButtonPress,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings_rounded, size: AppDimensions.iconLg),
          onPressed: onSettingsButtonPress,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: Icon(Icons.code_rounded, size: AppDimensions.iconLg),
          onPressed: onCodeButtonPress,
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
      ],
    );
  }
}
