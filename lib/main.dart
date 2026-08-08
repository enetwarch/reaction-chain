import 'package:flutter/material.dart';
import 'package:reaction_chain/screens/home_screen.dart';
import 'package:reaction_chain/screens/local_play_screen.dart';
import 'package:reaction_chain/theme/app_theme.dart';

void main() {
  runApp(const App());
}

enum Screen { home, localPlay }

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Screen _screen = Screen.home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Chain',
      theme: AppTheme.dark,
      home: switch (_screen) {
        // The app uses an manual screen switching approach for navigation.
        // Since Reaction Chain is a game, it does not use a conventional stack.
        // This allows free movement between each screen, similar to web apps.
        Screen.home => HomeScreen(
          onPlayButtonPress: () => setState(() => _screen = Screen.localPlay),
          onInfoButtonPress: () {},
          onSettingsButtonPress: () {},
          onCodeButtonPress: () {},
        ),
        Screen.localPlay => LocalPlayScreen(
          onBackButtonPress: () => setState(() => _screen = Screen.home),
          onPlayButtonPress: () {},
        ),
      },
    );
  }
}
