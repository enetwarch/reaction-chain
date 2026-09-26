import 'package:flutter/material.dart';
import 'package:reaction_chain/data/game_state.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/providers/local_storage_provider.dart';
import 'package:reaction_chain/screens/game_screen.dart';
import 'package:reaction_chain/screens/home_screen.dart';
import 'package:reaction_chain/screens/local_lobby_screen.dart';
import 'package:reaction_chain/services/local_storage.dart';
import 'package:reaction_chain/theme/app_scroll.dart';
import 'package:reaction_chain/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(preferences);

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
      builder: (context) => App(localStorage: localStorage),
    ),
  );
}

class App extends StatelessWidget {
  final LocalStorage localStorage;

  const App({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return LocalStorageProvider(
      localStorage: localStorage,
      child: MaterialApp(
        title: 'Reaction Chain',
        theme: AppTheme.dark,
        scrollBehavior: AppScrollBehavior(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/local-lobby': (context) => LocalLobbyScreen(),
          '/game': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            return args is GameState
                ? GameScreen(savedState: args)
                : GameScreen(players: args as List<Player>);
          },
        },
        home: HomeScreen(),
      ),
    );
  }
}
