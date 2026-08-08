import 'package:flutter/material.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSettingsButtonPress;
  final VoidCallback onPlayButtonPress;
  final VoidCallback onWifiButtonPress;

  const HomeScreen({
    super.key,
    required this.onSettingsButtonPress,
    required this.onPlayButtonPress,
    required this.onWifiButtonPress,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppDimensions.spacingLg,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.settings_rounded,
                        size: AppDimensions.iconLg,
                      ),
                      onPressed: onSettingsButtonPress,
                      style: Theme.of(context).iconButtonTheme.style?.copyWith(
                        fixedSize: WidgetStatePropertyAll(
                          AppDimensions.iconButtonLg,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: AppDimensions.iconLg,
                      ),
                      onPressed: onPlayButtonPress,
                      style: Theme.of(context).iconButtonTheme.style?.copyWith(
                        fixedSize: WidgetStatePropertyAll(
                          AppDimensions.iconButtonLg,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.wifi_rounded,
                        size: AppDimensions.iconLg,
                      ),
                      onPressed: onWifiButtonPress,
                      style: Theme.of(context).iconButtonTheme.style?.copyWith(
                        fixedSize: WidgetStatePropertyAll(
                          AppDimensions.iconButtonLg,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
