import 'package:flutter/material.dart';
import 'package:reaction_chain/screens/local_lobby_screen.dart';
import 'package:reaction_chain/theme/app_dimensions.dart';

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
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: AppDimensions.iconXl,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocalLobbyScreen(),
                        ),
                      );
                    },
                    style: Theme.of(context).iconButtonTheme.style?.copyWith(
                      fixedSize: WidgetStatePropertyAll(
                        AppDimensions.iconButtonXl,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buttonRow(context),
                ],
              ),
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
          onPressed: () {},
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings_rounded, size: AppDimensions.iconLg),
          onPressed: () {},
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
        IconButton(
          icon: Icon(Icons.code_rounded, size: AppDimensions.iconLg),
          onPressed: () {},
          style: Theme.of(context).iconButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(AppDimensions.iconButtonLg),
          ),
        ),
      ],
    );
  }
}
