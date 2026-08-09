import 'package:flutter/material.dart';
import 'package:reaction_chain/screens/home_screen.dart';
import 'package:reaction_chain/screens/local_lobby_screen.dart';
import 'package:reaction_chain/theme/app_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Chain',
      theme: AppTheme.dark,
      routes: {
        '/home': (context) => HomeScreen(),
        '/local-lobby': (context) => LocalLobbyScreen(),
      },
      home: HomeScreen(),
    );
  }
}
