import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final ButtonStyle _buttonStyle = IconButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    backgroundColor: const Color(0xFF1A1F25),
    foregroundColor: const Color(0xFFE6E6E6),
    fixedSize: const Size(100, 100),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1317),
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 32, vertical: 64),
          child: Center(
            child: Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Text(
                  'Reaction\nChain',
                  key: const Key('Title'),
                  textAlign: .center,
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    color: Color(0xFFE6E6E6),
                    fontWeight: .bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: .center,
                  spacing: 16,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings_rounded, size: 80),
                      onPressed: () {},
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: Icon(Icons.play_arrow_rounded, size: 80),
                      onPressed: () {},
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: Icon(Icons.wifi_rounded, size: 80),
                      onPressed: () {},
                      style: _buttonStyle,
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
