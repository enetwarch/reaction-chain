import 'package:flutter/material.dart';
import 'package:reaction_chain/screens/home_screen.dart';
import 'package:reaction_chain/screens/local_lobby_screen.dart';
import 'package:reaction_chain/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      // DevicePreview draws a phone frame around your app, so it is judged at the
      // size it was designed for instead of stretched across a laptop window.
      //
      // It is left ON in the deployed build on purpose: your live link is opened
      // on a desktop browser, and a phone layout at full desktop width looks
      // broken when it is not. The toolbar also lets a visitor switch device and
      // orientation.
      //
      // Want the clean app with no frame instead (for a portfolio, or because
      // you made the layout properly responsive)? Add
      //   import 'package:flutter/foundation.dart' show kReleaseMode;
      // and set `enabled: !kReleaseMode`, which drops the frame in release builds.
      enabled: true,
      builder: (context) => const App(),
    ),
  );
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
