import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static final ButtonStyle _buttonStyle = IconButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    backgroundColor: const Color(0xFF1A1F25),
    foregroundColor: const Color(0xFFE6E6E6),
    fixedSize: const Size(100, 100),
  );

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
      backgroundColor: const Color(0xFF0F1317),
      body: SafeArea(
        child: Container(
          padding: const .symmetric(horizontal: 32, vertical: 64),
          child: Center(
            child: Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              spacing: 32,
              children: [
                Text(
                  'Reaction\nChain',
                  key: const Key('title'),
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
                      onPressed: onSettingsButtonPress,
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: Icon(Icons.play_arrow_rounded, size: 80),
                      onPressed: onPlayButtonPress,
                      style: _buttonStyle,
                    ),
                    IconButton(
                      icon: Icon(Icons.wifi_rounded, size: 80),
                      onPressed: onWifiButtonPress,
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
